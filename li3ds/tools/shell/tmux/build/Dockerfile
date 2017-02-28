# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  exuberant-ctags cmake libevent-dev libncurses5-dev automake pkg-config 
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/tmux/tmux.git
WORKDIR tmux
RUN sh autogen.sh
RUN ./configure && make &&  make install
CMD ["tmux"]