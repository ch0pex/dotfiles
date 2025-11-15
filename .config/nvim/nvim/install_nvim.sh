#!/usr/bin/env bash

set -e

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

else
  echo "Homebrew already installed."
fi

# Install required packages
brew install neovim lazygit fish ast-grep lua@5.1 imagemagick git

# Ensure brew env is loaded
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>"$HOME/.bashrc"
source "$HOME/.bashrc"

# Clone Neovim config
NVIM_CONFIG_DIR="$HOME/.config/nvim"

if [ -d "$NVIM_CONFIG_DIR" ]; then
  mv "$NVIM_CONFIG_DIR" "${NVIM_CONFIG_DIR}_backup_$(date +%s)"
fi

git clone https://github.com/ch0pex/nvim.git "$NVIM_CONFIG_DIR"

# Sync plugins
nvim --headless "+Lazy! sync" +qa

echo "Setup complete."
