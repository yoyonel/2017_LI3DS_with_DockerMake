# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  --no-install-recommends \
  locales \
  libcanberra-gtk-module \
  ca-certificates \
  curl \
  tar \
  bzip2 \
  libglib2.0-0 \
  libx11-6 \
  libcairo2 \
  libpango-1.0-0 \
  libpangocairo-1.0-0 \
  libgtk2.0-0
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV SUBLIME_VERSION build_3126

#RUN curl -sSL "https://download.sublimetext.com/sublime_text_3_${SUBLIME_VERSION}_x64.tar.bz2" -o /tmp/sublime.tar.bz2 \
#RUN wget "https://download.sublimetext.com/sublime_text_3_${SUBLIME_VERSION}_x64.tar.bz2" -O /tmp/sublime.tar.bz2 \
COPY sublime_text_3_build_3126_x64.tar.bz2 /tmp/sublime.tar.bz2
RUN echo "install SublimeText3" \
  && mkdir -p /usr/src/sublime_text \
  && tar -xjf /tmp/sublime.tar.bz2 -C /usr/src/sublime_text --strip-components 1 \
  && rm /tmp/sublime.tar.bz2*

# RUN apt-get -y update \
  # && apt-get -y install \
RUN apt-get -y install \
  language-pack-en-base
RUN apt-get install sudo
RUN sudo apt-get purge -y locales
RUN sudo apt-get install -y locales 
  # \
  # && apt-get clean \
  # && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN sudo dpkg-reconfigure --force locales


# Generate system-wide UTF-8 locale
# Sublime might nag about Ascii issue w/ Package Control otherwise
RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
  locale-gen && \
  echo "LANG=en_US.UTF-8" > /etc/locale.conf

ENV LC_CTYPE=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANG_ALL=

# In order to prevent writing as root:root in Sublime, we have to run the Sublime Text container
# as the user that creates the container. Normally we do this by passing $UID.
# But just passing $UID along isn't enough - Sublime has to be started by a user that exists.
# By default in the container, the only user that actually exists is root.
# Therefore we have to create a new user, and start Sublime as that user.
# This is not possible at build time, so the /run.sh script accepts an environment
# variable called $NEWUSER that creates a user and group named $USER.
# Additional note: Sublime puts a lot of stuff in ~/.config, which is mounted at runtime. Without this directory being mounted, settings/packages/etc won't persist.
COPY run.sh /launch_st3.sh
RUN chmod +x /launch_st3.sh

CMD ["/launch_st3.sh"]