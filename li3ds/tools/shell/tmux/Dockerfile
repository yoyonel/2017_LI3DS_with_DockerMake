# RUN apt-get install -y exuberant-ctags cmake libevent-dev libncurses5-dev automake pkg-config
# RUN git clone https://github.com/tmux/tmux.git
# WORKDIR tmux
# RUN sh autogen.sh
# RUN ./configure && make &&  make install
# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
    tmux 
  #   \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# RUN echo 'set -g default-terminal "screen-256color"' >> .tmux.conf
COPY .tmux.conf /root/.tmux.conf

# installation de tmuxp: http://tmuxp.git-pull.com/en/latest/quickstart.html
RUN pip install tmuxp

CMD ["tmux"]