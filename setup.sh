#!/usr/bin/bash

USER=$1
HOME=/home/${USER}

# Detect package manager
detect_pkg_manager() {
  if command -v apt &>/dev/null; then
    PKG_MANAGER="apt"
  elif command -v dnf &>/dev/null; then

    PKG_MANAGER="dnf"
  elif command -v yum &>/dev/null; then
    PKG_MANAGER="yum"
  elif command -v pacman &>/dev/null; then
    PKG_MANAGER="pacman"
  else
    echo "Unsupported package manager. Exiting."
    exit 1
  fi
}

install_packages() {
  echo "--------------------- Installing core utilities ------------------------------"
  case "$PKG_MANAGER" in
  apt)
    sudo apt update
    sudo apt install -y python3 ninja-build cmake ripgrep unzip curl git build-essential gettext lua5.1 fish
    ;;
  dnf | yum)
    sudo $PKG_MANAGER install -y python3 ninja-build cmake ripgrep unzip curl git gcc gcc-c++ make gettext lua fish
    ;;
  pacman)
    sudo pacman -Sy --noconfirm python ninja cmake ripgrep unzip curl git base-devel gettext lua fish
    ;;
  esac
}

init_setup() {
  echo "--------------------- Setting up user environment for ${USER} ------------------------------"
  cp -r .tmux.conf .bashrc .config/ "${HOME}/" 2>/dev/null

  sudo chown -R "${USER}:${USER}" "${HOME}/.tmux.conf" "${HOME}/.bashrc" "${HOME}/.config"
  echo "Configuration files successfully copied to ${HOME} (owned by ${USER})"
}

install_neovim() {
  echo "--------------------- Installing Neovim ------------------------------"
  if command -v nvim &>/dev/null; then

    NVIM_VER=$(nvim --version | head -n1 | awk '{print $2}')
    if [ "$(printf '%s\n' '0.11.0' "$NVIM_VER" | sort -V | head -n1)" = "0.11.0" ]; then

      echo "Neovim $NVIM_VER is already installed. Skipping installation."
      return 0
    fi
  fi

  mkdir -p downloads && cd downloads || exit
  curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
  tar xvf nvim-linux-x86_64.tar.gz

  sudo rm -rf /opt/nvim-linux-x86_64/
  sudo mv nvim-linux-x86_64/ /opt/
  sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed: $(nvim --version | head -n1)"
  cd .. && rm -rf downloads
}

install_lazygit() {

  echo "--------------------- Installing Lazygit ------------------------------"
  if command -v lazygit &>/dev/null; then
    echo "Lazygit $(lazygit --version) is already installed. Skipping installation."
    return 0
  fi

  mkdir -p downloads && cd downloads || exit
  curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz"
  tar xvf lazygit_0.54.2_linux_x86_64.tar.gz

  sudo install lazygit /usr/local/bin

  echo "Lazygit installed: $(lazygit --version)"
  cd .. && rm -rf downloads
}

install_languages() {
  echo "--------------------- Installing programming languages ------------------------------"
  case "$PKG_MANAGER" in
  apt)
    sudo apt install -y clang gcc g++ gdb
    ;;
  dnf | yum)
    sudo $PKG_MANAGER install -y clang gcc gcc-c++ gdb
    ;;
  pacman)
    sudo pacman -Sy --noconfirm clang gcc gdb
    ;;
  esac

  # Go
  echo "Installing Go..."
  if [ -f go1.25.0.linux-amd64.tar.gz ]; then
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
    echo "Go installed successfully."
  else
    echo "Go tarball not found. Skipping Go installation."

  fi

  # Rust
  echo "Installing Rust..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  sudo -u $USER source $HOME/.cargo/env
  echo "Rust installed successfully."
}

# Main
detect_pkg_manager
install_packages
init_setup

install_neovim
install_lazygit
install_languages

echo "--------------------- Setup complete! ------------------------------"
