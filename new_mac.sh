#!/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update && brew upgrade && brew autoremove && brew cleanup
brew install docker docker-compose docker-buildx
brew install colima
colima start
brew services start colima
sudo ln -s ~/.colima/default/docker.sock /var/run/docker.sock

# Ensure Docker CLI plugins are discoverable (Buildx is a CLI plugin)
mkdir -p ~/.docker/cli-plugins
ln -sf "$(brew --prefix)/bin/docker-buildx" ~/.docker/cli-plugins/docker-buildx

brew install cmake
brew install zsh-completions
echo 'if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi' >> ~/.zshrc
chmod go-w '/opt/homebrew/share'
chmod -R go-w '/opt/homebrew/share/zsh'
brew install sox nmap opentofu awk ffmpeg htop yt-dlp telnet grpcurl coreutils \
  stats
# brew install --cask background-music
brew install --cask obs

# Ensure zsh completion is initialized
ZSHRC="${HOME}/.zshrc"
if ! grep -qxF 'autoload -Uz compinit && compinit' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'autoload -Uz compinit && compinit' >> "$ZSHRC"
fi
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
  ' >> $ZSHRC
fi

# Configure Git: auto-setup remote on first push
git config --global push.autoSetupRemote true

curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv python install 3.13
uv venv --python 3.13 ~/resources/python/venv3.13 --seed
source ~/resources/python/venv3.13/bin/activate
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

npm install -g @openai/codex
