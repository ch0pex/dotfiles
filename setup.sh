#!/usr/bin/bash

function init_setup() {
  cp -r .tmux.conf .bashrc ~ 2>/dev/null

  cd ~
  echo "Moving home $(pwd)"

  tmux source-file ~/.tmux.conf 2>/dev/null
  source ~/.bashrc
  return 0
}

function install_basics() {
  echo "--------------------- Installing COre utilities ------------------------------"
  sudo apt update

  sudo apt install python3 ninja-build cmake -y
  sudo apt install unzip curl git build-essential gettext lua5.4 fish -y
  return 0
}

function install_neovim() {
  echo "--------------------- Installing Neovim ------------------------------"
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz &&
    tar xzf nvim-linux64.tar.gz &&
    sudo mv nvim-linux64 /opt/ &&
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim &&
    nvim --version
  return 0
}

function install_lazygit() {
  echo "--------------------- Installing Lazygit ------------------------------"
  curl -LO https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_$(uname -s)_$(uname -m).tar.gz &&
    tar xf lazygit_$(uname -s)_$(uname -m).tar.gz lazygit &&
    sudo install lazygit /usr/local/bin &&
    lazygit --version
  return 0
}

function install_languages() {
  echo "--------------------- Installing programming languages ------------------------------"

  # C++
  sudo apt install -y build-essential clang gcc g++ gdb

  # Go
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

  # Rust
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source $HOME/.cargo/env

  return 0
}

install_basics
install_neovim
install_lazygit
install_languages
