#!/usr/bin/bash

USER=${1:-root}
HOME=${HOME:-/root}

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
    apt update
    apt install -y python3 ninja-build cmake ripgrep unzip curl git build-essential gettext lua5.1 fish wget tar pipx
    ;;
  dnf | yum)
    $PKG_MANAGER install -y python3 ninja-build cmake ripgrep unzip curl git make gettext lua fish wget tar tmux pipx gawk libglvnd-devel \
      mesa-libGL-devel libxcb-devel libfontenc-devel libXaw-devel libXcomposite-devel libstdc++-static re2c libcxx libcxx-devel libcxx-static \
      kubernetes helm
    ;;

  pacman)
    pacman -Sy --noconfirm python ninja cmake ripgrep unzip curl git base-devel gettext lua fish wget tar
    ;;
  esac
}

init_setup() {
  echo "--------------------- Setting up user environment for ${USER} ------------------------------"
  cp -r .tmux.conf .bashrc .config/ "${HOME}/" 2>/dev/null
  echo "Configuration files copied to ${HOME}"
}

install_neovim() {
  echo "--------------------- Installing Neovim ------------------------------"
  if command -v nvim &>/dev/null; then
    NVIM_VER=$(nvim --version | head -n1 | awk '{print $2}')
    if [ "$(printf '%s\n' '0.11.0' "$NVIM_VER" | sort -V | head -n1)" = "0.11.0" ]; then
      echo "Neovim $NVIM_VER already installed. Skipping."
      return

    fi
  fi

  curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz"
  tar xvf nvim-linux-x86_64.tar.gz
  rm -rf /opt/nvim-linux-x86_64/
  mv nvim-linux-x86_64/ /opt/
  ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim
  echo "Neovim installed: $(nvim --version | head -n1)"
  rm -rf nvim-linux-x86_64.tar.gz
}

install_lazygit() {
  echo "--------------------- Installing Lazygit ------------------------------"
  if command -v lazygit &>/dev/null; then
    echo "Lazygit $(lazygit --version) already installed. Skipping."

    return
  fi
  curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz"
  tar xvf lazygit_0.54.2_linux_x86_64.tar.gz
  install lazygit /usr/local/bin

  echo "Lazygit installed: $(lazygit --version)"
  rm -rf lazygit_0.54.2_linux_x86_64.tar.gz lazygit
}

install_languages() {
  echo "--------------------- Installing programming languages ------------------------------"
  case "$PKG_MANAGER" in
  apt)
    apt install -y clang gcc g++ mingw-w64
    ;;
  dnf | yum)
    $PKG_MANAGER install -y clang gcc gcc-c++ gdb mingw64-gcc mingw64-gcc-c++ mingw64-winpthreads-static
    ;;
  pacman)
    pacman -Sy --noconfirm clang gcc gdb
    ;;
  esac

  # Go
  echo "Installing Go..."
  curl -LO https://go.dev/dl/go1.25.0.linux-amd64.tar.gz
  rm -rf /usr/local/go
  tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz
  rm go1.25.0.linux-amd64.tar.gz

  export PATH=$PATH:/usr/local/go/bin

  # Rust
  echo "Installing Rust..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y

  export PATH=$HOME/.cargo/bin:$PATH
}

# Main
detect_pkg_manager

install_packages
init_setup
install_neovim
install_lazygit
install_languages

echo "--------------------- Conan install ------------------------------"
pipx ensurepath
pipx install conan
source $HOME/.bashrc
conan profile detect

echo "--------------------- Git config ------------------------------"
git config --global user.email "acbsur1@gmail.com"
git config --global user.name "ch0pex"
git config --global credential.helper store

echo "--------------------- k3s ------------------------------"
curl -sfL https://get.k3s.io | sh -

echo "--------------------- Setup complete! ------------------------------"
