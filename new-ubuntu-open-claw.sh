#!/usr/bin/env bash
set -euo pipefail

# Fast Ubuntu bootstrap for a future OpenClaw laptop.
# It installs packages and configures the local user environment,
# but does not intentionally reboot the machine.

log() {
  printf '\n[%s] %s\n' "$(date '+%F %T')" "$*"
}

warn() {
  printf '\n[WARN] %s\n' "$*" >&2
}

need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing required command: $1" >&2
    exit 1
  }
}

apt_pkg_installed() {
  dpkg -s "$1" >/dev/null 2>&1
}

install_apt_packages() {
  local missing=()
  for pkg in "$@"; do
    apt_pkg_installed "$pkg" || missing+=("$pkg")
  done

  if ((${#missing[@]} == 0)); then
    log "APT packages already installed."
    return
  fi

  log "Installing APT packages: ${missing[*]}"
  sudo apt-get install -y "${missing[@]}"
}

ensure_apt_keyring_dir() {
  sudo install -d -m 0755 /etc/apt/keyrings
}

ensure_block_in_file() {
  local marker="$1"
  local file="$2"
  local content="$3"
  touch "$file"
  if ! grep -Fq "$marker" "$file" 2>/dev/null; then
    printf '\n%s\n' "$content" >> "$file"
  fi
}

configure_vscode_repo() {
  if [ -f /etc/apt/sources.list.d/vscode.list ]; then
    log "VS Code APT repo already configured."
    return
  fi

  log "Configuring VS Code APT repository"
  ensure_apt_keyring_dir
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/packages.microsoft.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/packages.microsoft.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" \
    | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
}

configure_google_chrome_repo() {
  if [ -f /etc/apt/sources.list.d/google-chrome.list ]; then
    log "Google Chrome APT repo already configured."
    return
  fi

  log "Configuring Google Chrome APT repository"
  ensure_apt_keyring_dir
  curl -fsSL https://dl.google.com/linux/linux_signing_key.pub \
    | gpg --dearmor \
    | sudo tee /etc/apt/keyrings/google-chrome.gpg >/dev/null
  sudo chmod go+r /etc/apt/keyrings/google-chrome.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" \
    | sudo tee /etc/apt/sources.list.d/google-chrome.list >/dev/null
}

configure_docker_repo() {
  if [ -f /etc/apt/sources.list.d/docker.list ]; then
    log "Docker APT repo already configured."
    return
  fi

  log "Configuring Docker APT repository"
  ensure_apt_keyring_dir
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
    | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  sudo chmod a+r /etc/apt/keyrings/docker.gpg
  . /etc/os-release
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu ${VERSION_CODENAME} stable" \
    | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
}

apt_update() {
  log "Running apt-get update"
  sudo apt-get update
}

install_base_packages() {
  install_apt_packages \
    apt-transport-https \
    apache2-utils \
    ca-certificates \
    copyq \
    curl \
    gdebi \
    gnome-shell-extensions \
    gnupg \
    htop \
    lm-sensors \
    ncdu \
    net-tools \
    nmap \
    p7zip-full \
    python3-pip \
    python3-venv \
    wget \
    whois
}

install_docker_packages() {
  install_apt_packages \
    containerd.io \
    docker-buildx-plugin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin
}

ensure_docker_group_membership() {
  if id -nG "$USER" | tr ' ' '\n' | grep -qx docker; then
    log "User already in docker group."
  else
    log "Adding $USER to docker group"
    sudo usermod -aG docker "$USER"
    warn "Docker group updated. Log out/in or reboot later to use Docker without sudo."
  fi
}

install_openclaw() {
  if command -v openclaw >/dev/null 2>&1; then
    log "OpenClaw already installed."
    return
  fi

  log "Installing OpenClaw (this also provisions modern Node/npm)"
  curl -fsSL https://openclaw.ai/install.sh | bash
}

refresh_shell_path() {
  export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"

  if [ -f "$HOME/.bashrc" ]; then
    # shellcheck disable=SC1090
    . "$HOME/.bashrc" || true
  fi

  hash -r
}

ensure_npm_after_openclaw() {
  if command -v npm >/dev/null 2>&1; then
    return
  fi

  warn "npm is still unavailable after the OpenClaw installer. Falling back to Node.js 24 from NodeSource."
  curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
  apt_update
  install_apt_packages nodejs
  refresh_shell_path
}

configure_npm_global_prefix() {
  if ! command -v npm >/dev/null 2>&1; then
    warn "npm is still unavailable; skipping npm prefix configuration."
    return
  fi

  mkdir -p "$HOME/.npm-global/bin"
  if [ "$(npm config get prefix 2>/dev/null || true)" != "$HOME/.npm-global" ]; then
    log "Configuring a user-writable npm global prefix at $HOME/.npm-global"
    npm config set prefix "$HOME/.npm-global"
  fi

  refresh_shell_path
}

install_npm_cli() {
  local pkg="$1"
  local label="$2"

  if ! command -v npm >/dev/null 2>&1; then
    warn "npm not found yet; skipping $label for now. Re-run after OpenClaw install finishes provisioning Node/npm."
    return
  fi

  if npm list -g --depth=0 "$pkg" >/dev/null 2>&1; then
    log "$label already installed globally."
    return
  fi

  log "Installing $label ($pkg)"
  npm install -g "$pkg"
}

configure_copyq() {
  if ! command -v copyq >/dev/null 2>&1; then
    warn "CopyQ not installed; skipping configuration."
    return
  fi

  log "Configuring CopyQ"
  copyq config autostart true || true
  copyq config maxitems 20000 || true

  mkdir -p "$HOME/.config/autostart"
  cat > "$HOME/.config/autostart/copyq.desktop" <<'EOF'
[Desktop Entry]
Type=Application
Name=CopyQ
Exec=copyq
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Comment=Start CopyQ on login
EOF
}

configure_bash_history() {
  local bashrc="$HOME/.bashrc"
  if ! grep -Fq '# OPENCLAW_BASH_HISTORY_TUNING' "$bashrc" 2>/dev/null; then
    cat >> "$bashrc" <<'EOF'

# OPENCLAW_BASH_HISTORY_TUNING
export HISTSIZE=1000000
export HISTFILESIZE=2000000
export HISTCONTROL=ignoredups:erasedups
shopt -s histappend
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$PATH"
EOF
  fi
}

configure_no_lid_sleep_and_lock() {
  if ! command -v gsettings >/dev/null 2>&1; then
    warn "gsettings unavailable; skipping user-session lid/lock configuration."
    return
  fi

  log "Configuring GNOME to stay awake/unlocked with lid closed"
  gsettings set org.gnome.settings-daemon.plugins.power lid-close-ac-action 'nothing' || true
  gsettings set org.gnome.settings-daemon.plugins.power lid-close-battery-action 'nothing' || true
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing' || true
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0 || true
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing' || true
  gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 0 || true
  gsettings set org.gnome.desktop.screensaver lock-enabled false || true
  gsettings set org.gnome.desktop.screensaver idle-activation-enabled false || true
  gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false || true
  gsettings set org.gnome.desktop.lockdown disable-lock-screen true || true

  mkdir -p "$HOME/.config/systemd/user"
  cat > "$HOME/.config/systemd/user/no-lid-sleep.service" <<'EOF'
[Unit]
Description=Keep laptop running unlocked when lid is closed
After=graphical-session.target

[Service]
Type=simple
ExecStart=/usr/bin/systemd-inhibit --what=handle-lid-switch:sleep --mode=block --why=Keep_laptop_awake_and_unlocked_with_lid_closed /usr/bin/sleep infinity
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF
  systemctl --user daemon-reload || true
  systemctl --user enable --now no-lid-sleep.service || true
}

print_optional_followups() {
  cat <<'EOF'

Optional/manual follow-ups intentionally left out of automatic installation:
- antigravity (package/source intentionally not assumed here)
- any secrets/API key login steps for OpenClaw, Codex, Claude Code, Gemini CLI, Docker registries, etc.
- root-level /etc/systemd/logind.conf.d/ lid-close policy if you want system-wide enforcement beyond the user session

Recommended post-run checks:
- openclaw --help
- docker --version
- code --version
- google-chrome --version
- copyq config maxitems
EOF
}

main() {
  need_cmd sudo

  log "Preparing repositories and base tooling"
  sudo apt-get update
  install_apt_packages ca-certificates curl gnupg wget

  configure_vscode_repo
  configure_google_chrome_repo
  configure_docker_repo

  apt_update
  install_base_packages
  install_apt_packages code google-chrome-stable
  install_docker_packages
  ensure_docker_group_membership

  install_openclaw
  refresh_shell_path
  ensure_npm_after_openclaw
  configure_npm_global_prefix

  install_npm_cli @openai/codex "OpenAI Codex CLI"
  install_npm_cli @anthropic-ai/claude-code "Anthropic Claude Code"
  install_npm_cli @google/gemini-cli "Google Gemini CLI"

  configure_copyq
  configure_bash_history
  configure_no_lid_sleep_and_lock

  log "Done. Reboot later if you want docker group membership and desktop autostarts to apply cleanly."
  print_optional_followups
}

main "$@"
