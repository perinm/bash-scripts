#!/bin/bash
set -Eeuo pipefail

log() {
  printf '\n==> %s\n' "$1"
}

warn() {
  printf 'Warning: %s\n' "$1" >&2
}

declare -a BOOTSTRAP_WARNINGS=()

record_warning() {
  local message="$1"

  BOOTSTRAP_WARNINGS+=("$message")
  warn "$message"
}

print_summary() {
  if ((${#BOOTSTRAP_WARNINGS[@]} == 0)); then
    log "Bootstrap completed without recorded warnings"
    return
  fi

  printf '\nBootstrap completed with warnings:\n'
  printf ' - %s\n' "${BOOTSTRAP_WARNINGS[@]}"
}

find_php_extension_configs() {
  local extension="$1"
  local php_ini="$2"
  local ini_dir="$3"
  local candidate pattern
  local -a matches=()

  pattern="^[[:space:]]*extension[[:space:]]*=[[:space:]]*\"?${extension}\\.so\"?$"

  for candidate in "$php_ini" "$ini_dir"/*.ini; do
    [[ -f "$candidate" ]] || continue
    if grep -Eq "$pattern" "$candidate"; then
      matches+=("$candidate")
    fi
  done

  if ((${#matches[@]})); then
    printf '%s\n' "${matches[@]}"
  fi
}

report_php_extension_config_state() {
  local extension="$1"
  local config_paths="$2"
  local config_count

  config_count="$(printf '%s\n' "$config_paths" | awk 'NF { count++ } END { print count + 0 }')"

  if [[ "$config_count" -gt 1 ]]; then
    record_warning "PHP extension '$extension' is configured in multiple files. Review the paths below."
    printf '%s\n' "$config_paths"
  elif [[ "$config_count" -eq 1 ]]; then
    log "PHP extension '$extension' is already configured in:"
    printf '%s\n' "$config_paths"
  fi
}

ensure_homebrew_php_layout() {
  local ini_dir ext_dir

  log "Repairing Homebrew PHP postinstall layout"
  brew postinstall php

  ini_dir="$(php-config --ini-dir)"
  ext_dir="$(pecl config-get ext_dir)"

  mkdir -p "$ini_dir"
  mkdir -p "$ext_dir"
}

install_pecl_extension() {
  local extension="$1"
  local ini_name="$2"
  local ini_dir ext_dir php_ini so_path ini_path existing_config

  ini_dir="$(php-config --ini-dir)"
  ext_dir="$(pecl config-get ext_dir)"
  php_ini="$(php --ini | awk -F': ' '/Loaded Configuration File/ {print $2}')"
  so_path="$ext_dir/${extension}.so"
  ini_path="$ini_dir/${ini_name}"
  existing_config="$(find_php_extension_configs "$extension" "$php_ini" "$ini_dir")"

  report_php_extension_config_state "$extension" "$existing_config"

  if php -m | grep -qx "$extension"; then
    if [[ -z "$existing_config" ]]; then
      record_warning "PHP extension '$extension' is loaded, but no persistent config file was found."
    fi
    log "PHP extension '$extension' is already loaded"
    return 0
  fi

  if [[ -f "$so_path" ]]; then
    log "Found existing PECL shared object for '$extension' at $so_path"
  else
    log "Installing PECL extension '$extension'"
    if ! pecl install "$extension"; then
      warn "PECL install failed for '$extension'."
      return 1
    fi
  fi

  if [[ ! -f "$so_path" ]]; then
    warn "PECL setup for '$extension' failed because ${so_path} is missing."
    return 1
  fi

  if [[ -z "$existing_config" ]]; then
    printf 'extension=%s.so\n' "$extension" > "$ini_path"
  fi

  if ! php --ri "$extension" >/dev/null; then
    warn "PHP extension '$extension' is not loadable after configuration."
    return 1
  fi
  log "PHP extension '$extension' is loadable"
}

setup_php_extensions() {
  local pecl_failed=0

  if ! pecl channel-update pecl.php.net; then
    record_warning "Failed to update the PECL channel. Skipping PHP extension setup."
    return 0
  fi

  if ! ensure_homebrew_php_layout; then
    record_warning "Failed to repair the Homebrew PHP layout. Skipping PHP extension setup."
    return 0
  fi

  if ! install_pecl_extension grpc ext-grpc.ini; then
    record_warning "PHP extension 'grpc' failed to install or load. Continuing without it."
    pecl_failed=1
  fi

  if ! install_pecl_extension opentelemetry ext-opentelemetry.ini; then
    record_warning "PHP extension 'opentelemetry' failed to install or load. Continuing without it."
    pecl_failed=1
  fi

  if [[ "$pecl_failed" -eq 0 ]]; then
    log "Confirmed PHP extensions grpc and opentelemetry"
  fi
}

verify_colima_runtime() {
  local docker_context=""

  log "This machine is intentionally Colima-backed for Docker"

  if docker_context="$(docker context show 2>/dev/null)"; then
    log "Active Docker context: $docker_context"
  else
    record_warning "Could not determine the active Docker context after Colima startup."
  fi

  if ! docker info >/dev/null 2>&1; then
    warn "Docker is not reachable after Colima startup."
    return 1
  fi

  log "Docker is reachable through Colima"
}

configure_skhd_shortcut() {
  local skhd_config="${HOME}/.skhdrc"

  if ! grep -qxF 'ctrl + cmd - t : open -b com.googlecode.iterm2' "$skhd_config" 2>/dev/null; then
    printf '\n%s\n' 'ctrl + cmd - t : open -b com.googlecode.iterm2' >> "$skhd_config"
  fi

  if skhd --restart-service || skhd --start-service; then
    echo "Configured Ctrl+Cmd+T to open iTerm2 (grant Accessibility permission to skhd if prompted)."
  else
    record_warning "skhd could not start automatically. Grant Accessibility permission to skhd, then start the service manually for Ctrl+Cmd+T."
  fi
}

if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install 2>/dev/null || true
fi

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

BREW_PREFIX="$(brew --prefix)"
BREW_SHARE="${BREW_PREFIX}/share"
BREW_ZSH_DIR="${BREW_PREFIX}/share/zsh"
ZSHRC="${HOME}/.zshrc"

brew update && brew upgrade && brew autoremove && brew cleanup
brew install docker docker-compose docker-buildx
brew install colima
colima start
brew services start colima
verify_colima_runtime

# Ensure Docker CLI plugins are discoverable (Buildx is a CLI plugin)
mkdir -p "${HOME}/.docker/cli-plugins"
ln -sf "${BREW_PREFIX}/bin/docker-buildx" "${HOME}/.docker/cli-plugins/docker-buildx"

brew install cmake
brew install zsh-completions
if ! grep -qxF 'FPATH=$(brew --prefix)/share/zsh-completions:$FPATH' "$ZSHRC" 2>/dev/null; then
  cat <<'EOF' >> "$ZSHRC"
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi
EOF
fi
if [[ -d "$BREW_SHARE" ]]; then
  chmod go-w "$BREW_SHARE"
fi
if [[ -d "$BREW_ZSH_DIR" ]]; then
  chmod -R go-w "$BREW_ZSH_DIR"
fi
brew install sox nmap opentofu awk ffmpeg htop yt-dlp telnet grpcurl coreutils \
  stats bash gemini-cli codex claude-code gcc make autoconf pkgconf openssl@3 php \
  ncdu
# brew install --cask background-music
brew install --cask obs
brew install --cask iterm2
brew install --cask iina
brew install asmvik/formulae/skhd
brew install --cask steipete/tap/codexbar

setup_php_extensions

# Add a global shortcut: Ctrl+Cmd+T opens iTerm2
configure_skhd_shortcut

# Ensure zsh completion is initialized
if ! grep -qxF 'export DOCKER_BUILDKIT=1' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'export DOCKER_BUILDKIT=1' >> "$ZSHRC"
fi
if ! grep -qxF 'export COMPOSE_DOCKER_CLI_BUILD=1' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'export COMPOSE_DOCKER_CLI_BUILD=1' >> "$ZSHRC"
fi

# Increase shell history substantially (zsh)
if ! grep -qxF 'HISTSIZE=1000000' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'HISTSIZE=1000000' >> "$ZSHRC"
fi
if ! grep -qxF 'SAVEHIST=1000000' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'SAVEHIST=1000000' >> "$ZSHRC"
fi
if ! grep -qxF 'HISTFILE=~/.zsh_history' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'HISTFILE=~/.zsh_history' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt APPEND_HISTORY' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt APPEND_HISTORY' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt INC_APPEND_HISTORY' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt INC_APPEND_HISTORY' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt SHARE_HISTORY' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt SHARE_HISTORY' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt HIST_IGNORE_ALL_DUPS' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt HIST_IGNORE_ALL_DUPS' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt HIST_REDUCE_BLANKS' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt HIST_REDUCE_BLANKS' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt EXTENDED_HISTORY' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt EXTENDED_HISTORY' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt HIST_IGNORE_SPACE' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt HIST_IGNORE_SPACE' >> "$ZSHRC"
fi
if ! grep -qxF 'setopt HIST_FCNTL_LOCK' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'setopt HIST_FCNTL_LOCK' >> "$ZSHRC"
fi
if ! grep -qxF 'tf() {' "$ZSHRC" 2>/dev/null; then
  echo '
  tf() {
      if [ -f .env ]; then
          source .env
      fi
      tofu "$@"
  }
  alias tf=tf
  ' >> "$ZSHRC"
fi

# Configure Git: auto-setup remote on first push
git config --global push.autoSetupRemote true

if ! command -v uv >/dev/null 2>&1; then
  curl -LsSf https://astral.sh/uv/install.sh | sh
fi
if [[ -x "${HOME}/.local/bin/uv" ]]; then
  export PATH="${HOME}/.local/bin:${PATH}"
fi
uv self update
uv python install 3.14
VENV_DIR="${HOME}/resources/python/venv3.14"
if [[ ! -f "${VENV_DIR}/bin/activate" ]]; then
  uv venv --python 3.14 "$VENV_DIR" --seed
fi
source "${VENV_DIR}/bin/activate"
uv pip install -U pip ruff setuptools setuptools-rust wheel

# Configure macOS KeyBindings for improved Home/End key behavior
# source: https://www.maketecheasier.com/fix-home-end-button-for-external-keyboard-mac/
KEYBIND_DIR="${HOME}/Library/KeyBindings"
mkdir -p "${KEYBIND_DIR}"
cat > "${KEYBIND_DIR}/DefaultKeyBinding.dict" <<'EOF'
{
/* Remap Home / End keys */
/* Home Button*/
"\UF729" = "moveToBeginningOfLine:"; 
/* End Button */
"\UF72B" = "moveToEndOfLine:"; 
/* Shift + Home Button */
"$\UF729" = "moveToBeginningOfLineAndModifySelection:"; 
/* Shift + End Button */
"$\UF72B" = "moveToEndOfLineAndModifySelection:"; 
/* Ctrl + Home Button */
"^\UF729" = "moveToBeginningOfDocument:"; 
/* Ctrl + End Button */
"^\UF72B" = "moveToEndOfDocument:"; 
 /* Shift + Ctrl + Home Button */
"$^\UF729" = "moveToBeginningOfDocumentAndModifySelection:";
/* Shift + Ctrl + End Button*/
"$^\UF72B" = "moveToEndOfDocumentAndModifySelection:"; 
}
EOF

echo "Installed custom macOS KeyBindings (restart apps to take effect)."

# Close Finder on exit
defaults write com.apple.finder QuitMenuItem -bool true; killall Finder

uv tool install it2

print_summary
