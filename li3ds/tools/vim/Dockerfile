### VIM: Fisa
#
# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  curl vim exuberant-ctags git ack-grep python-pip 
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#RUN pip --proxy http://proxy.ign.fr:3128 install pep8 flake8 pyflakes isort yapf
RUN pip install pep8 flake8 pyflakes isort yapf

# url: http://stackoverflow.com/questions/1078524/how-to-specify-the-location-with-wget
RUN wget https://raw.github.com/fisadev/fisa-vim-config/master/.vimrc -O ~/.vimrc
#
RUN (sleep 45s; echo ":qa") | vim | true

#
COPY run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]