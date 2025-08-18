#!/bin/bash

xcode-select --install

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew update && brew upgrade
brew install docker docker-compose
brew install colima
colima start
brew services start colima

brew install cmake
brew install zsh-completions
echo 'if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
    autoload -Uz compinit
    compinit
fi' >> ~/.zshrc
chmod go-w '/opt/homebrew/share'
chmod -R go-w '/opt/homebrew/share/zsh'
brew install --cask obs

# Ensure zsh completion is initialized
ZSHRC="${HOME}/.zshrc"
if ! grep -qxF 'autoload -Uz compinit && compinit' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'autoload -Uz compinit && compinit' >> "$ZSHRC"
fi

# Configure Git: auto-setup remote on first push
git config --global push.autoSetupRemote true

curl -LsSf https://astral.sh/uv/install.sh | sh
uv self update
uv python install 3.13
uv venv --python 3.13 ~/resources/python/venv3.13 --seed
source ~/resources/python/venv3.13/bin/activate
uv pip install -U pip ruff setuptools setuptools-rust wheel
