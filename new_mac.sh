#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install docker docker-compose
brew install colima
colima start
brew services start colima

# Ensure zsh completion is initialized
ZSHRC="${HOME}/.zshrc"
if ! grep -qxF 'autoload -Uz compinit && compinit' "$ZSHRC" 2>/dev/null; then
  printf '\n%s\n' 'autoload -Uz compinit && compinit' >> "$ZSHRC"
fi