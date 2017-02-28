# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  zsh 
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && chsh -s /bin/zsh
RUN echo '[[ $TMUX = "" ]] && export TERM="xterm-256color"' >> .zshrc

CMD ["zsh"]