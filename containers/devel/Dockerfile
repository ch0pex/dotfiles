FROM gcc:latest

ENV DEBIAN_FRONTEND=noninteractive


# Build essentials 
RUN apt-get update && \
  apt-get install -y --no-install-recommends \
  cmake \
  ninja-build \
  python3-pip \
  mingw-w64 \
  git \
  curl \
  unzip \
  lsb-release \
  zip \
  pipx \
  linux-base \
  linux-perf \
  ca-certificates && \
  rm -rf /var/lib/apt/lists/*

# Clang
RUN wget https://apt.llvm.org/llvm.sh && \
  chmod +x llvm.sh && \
  ./llvm.sh 20

# Conan 
RUN pipx ensurepath 
RUN pipx install conan 

# Install dotfiles 
RUN git clone https://github.com/ch0pex/dotfiles && \
  cd dotfiles && \
  chmod +x setup.sh &&\
  ./setup.sh


WORKDIR /root

CMD ["bash"]

