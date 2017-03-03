# url: https://github.com/sameersbn/docker-apt-cacher-ng#quickstart
# RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
#  && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

RUN apt-get -y install \
      realpath \
      curl \
      wget \
      git \
      python-pip \
      tar \
      bzip2 \
      locales \
      ca-certificates \
      software-properties-common  # for: add-apt-repository