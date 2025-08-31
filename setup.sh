#!/usr/bin/bash

USER=$1
HOME=/home/${USER}

function init_setup() {
  sudo cp -r .tmux.conf .bashrc .config/ ${HOME} 2>/dev/null

  cd ${HOME} 
  echo "Moving home $(pwd)"

  tmux source-file ${HOME}/.tmux.conf 2>/dev/null
  source ${HOME}/.bashrc
  return 0
}

function install_basics() {
  echo "--------------------- Installing Core utilities ------------------------------"
  sudo apt update

  sudo apt install python3 ninja-build cmake -y
  sudo apt install unzip curl git build-essential gettext lua5.4 fish -y
  return 0
}

function install_neovim() {
  echo "--------------------- Installing Neovim ------------------------------"
  mkdir downloads/
  cd downloads/
    if command -v nvim &> /dev/null; then

  curl -LO "https://github.com/neovim/neovim/releases/download/v0.11.4/nvim-linux-x86_64.tar.gz" &&
    tar xvf nvim-linux-x86_64.tar.gz &&
    mv cp nvim-linux-x86_64/bin/nvim /usr/bin/
    nvim --version
    fi

    
  echo "--------------------- Installing Lazygit ------------------------------"
    if command -v lazygit &> /dev/null; then
  curl -LO "https://github.com/jesseduffield/lazygit/releases/download/v0.54.2/lazygit_0.54.2_linux_x86_64.tar.gz"
    tar xfv "lazygit_0.54.2_linux_x86_64.tar.gz" &&
	mv lazygit /usr/bin && 
    lazygit --version

    fi
  cd ..
  rm -rf downloads/

  return 0
}

function install_languages() {
  echo "--------------------- Installing programming languages ------------------------------"

  # C++
  sudo apt install -y clang gcc g++ gdb

  # Go
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf go1.25.0.linux-amd64.tar.gz

  # Rust
  curl https://sh.rustup.rs -sSf | sh -s -- -y
  source $HOME/.cargo/env

  return 0
}

init_setup

