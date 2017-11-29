# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  zsh 	\
  bc
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
RUN cp ~/.oh-my-zsh/templates/zshrc.zsh-template ~/.zshrc && chsh -s /bin/zsh

# PowerLevel9K
RUN git clone \
		https://github.com/bhilburn/powerlevel9k.git \
		~/.oh-my-zsh/custom/themes/powerlevel9k

# SyntaxHighlighting
RUN git clone \
	https://github.com/zsh-users/zsh-syntax-highlighting.git \
	${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# AutoCompletion
RUN git clone \
	http://github.com/zsh-users/zsh-autosuggestions \
	${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Custom Configs
COPY .powerlevel9k /root/.powerlevel9k
COPY .zshrc /root/.zshrc

# Config SHELL pour les couleurs
# Ca ne fonctionne pas super super ... mais pas encore sure que ce soit vraiment nécessaire ...
# RUN echo '[[ $TMUX = "" ]] && export TERM="xterm-256color"' >> .zshrc
# RUN echo 'if [ -z $TMUX ]; then; tmux; fi' >> .zshrc

#
CMD ["zsh"]