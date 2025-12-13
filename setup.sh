#!/usr/bin/bash

# Arguments handling
# $1 = Command (full, install_conan, etc.)
# $2 = User (optional, default: root)

COMMAND=${1:-help}
TARGET_USER=${2:-root}
HOME_DIR=${HOME:-/root}

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------

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
  echo "Detected Package Manager: $PKG_MANAGER"
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
      kubernetes-client helm libxcb-devel libfontenc-devel libXaw-devel libXcomposite-devel \
      libXcursor-devel libXdmcp-devel libXtst-devel libXinerama-devel \
      libxkbfile-devel libXrandr-devel libXres-devel libXScrnSaver-devel \
      xcb-util-wm-devel xcb-util-image-devel xcb-util-keysyms-devel \
      xcb-util-renderutil-devel libXdamage-devel libXxf86vm-devel \
      libXv-devel xcb-util-devel xcb-util-cursor-devel libasan libasan-static libubsan libtsan \
      xorg-x11-server-Xvfb mesa-dri-drivers libXcursor libXrandr libXinerama parted libXi xorg-x11-xauth valgrind
    ;;
  pacman)

    pacman -Sy --noconfirm python ninja cmake ripgrep unzip curl git base-devel gettext lua fish wget tar
    ;;
  esac
}

init_setup() {
  echo "--------------------- Setting up user environment for ${TARGET_USER} ------------------------------"
  # Assuming dotfiles are present in the current directory
  cp -r .tmux.conf .bashrc .ssh/ .config/ "${HOME_DIR}/" 2>/dev/null || echo "Warning: Dotfiles not found in current dir, skipping copy."
  echo "Configuration files copied to ${HOME_DIR}"
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

    $PKG_MANAGER install -y clang gcc gcc-c++ gdb mingw64-gcc mingw64-gcc-c++ mingw64-winpthreads-static clang-format
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

  # Add to path for current session
  export PATH=$PATH:/usr/local/go/bin

  # Rust
  echo "Installing Rust..."
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  export PATH=$HOME_DIR/.cargo/bin:$PATH
}

install_conan() {
  echo "--------------------- Conan install ------------------------------"
  pipx ensurepath

  PIPX_CONAN_VENV="$HOME_DIR/.local/share/pipx/venvs/conan"
  if [ -d "$PIPX_CONAN_VENV" ]; then

    echo "Removing stale/broken conan venv at $PIPX_CONAN_VENV..."
    rm -rf "$PIPX_CONAN_VENV"
  fi

  pipx install conan --force

  export PATH=$PATH:$HOME_DIR/.local/bin

  if [ -n "$GITHUB_PATH" ]; then
    echo "$HOME_DIR/.local/bin" >>$GITHUB_PATH
  fi

  conan profile detect --force
  conan remote add chopex-conan http://77.42.44.81:31267/artifactory/api/conan/chopex-conan --force
}

install_git() {

  echo "--------------------- Git config ------------------------------"
  git config --global user.email "acbsur1@gmail.com"

  git config --global user.name "ch0pex"
  git config --global credential.helper store
}

install_k3s() {
  echo "--------------------- k3s ------------------------------"
  curl -sfL https://get.k3s.io | sh -
}

show_help() {

  echo "Usage: ./setup.sh <command> [user]"
  echo ""
  echo "Commands:"
  echo "  full               Run the complete setup"
  echo "  install_packages   Install system packages only"

  echo "  init_setup         Copy dotfiles"
  echo "  install_neovim     Install Neovim"
  echo "  install_lazygit    Install Lazygit"
  echo "  install_languages  Install GCC, Clang, Go, Rust"
  echo "  install_conan      Install and configure Conan"
  echo "  install_git        Configure Git globals"
  echo "  install_k3s        Install K3s"
}

# ------------------------------------------------------------------------------
# Main Execution Logic
# ------------------------------------------------------------------------------

# 1. Always detect package manager first (dependencies rely on it)
detect_pkg_manager

# 2. Execute requested command
case "$COMMAND" in
full)
  install_packages
  init_setup
  install_neovim
  install_lazygit
  install_languages
  install_conan
  install_git
  install_k3s
  echo "--------------------- Full Setup Complete! ------------------------------"
  ;;

install_packages)
  install_packages
  ;;
init_setup)
  init_setup
  ;;
install_neovim)
  install_neovim
  ;;
install_lazygit)
  install_lazygit
  ;;
install_languages)
  install_languages
  ;;
install_conan)
  install_conan
  ;;
install_git)
  install_git

  ;;
install_k3s)
  install_k3s
  ;;
help | *)
  show_help
  exit 1
  ;;
esac
