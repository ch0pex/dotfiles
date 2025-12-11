FROM fedora:latest

# Install dotfiles 
RUN git clone https://github.com/ch0pex/dotfiles && \
  cd dotfiles && \
  chmod +x setup.sh &&\
          ./setup.sh install_packages &&\
          ./setup.sh install_languages &&\
          ./setup.sh install_conan \

WORKDIR /root

CMD ["bash"]

