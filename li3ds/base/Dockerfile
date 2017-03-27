# url: https://github.com/sameersbn/docker-apt-cacher-ng#quickstart
# RUN echo 'Acquire::HTTP::Proxy "http://172.17.0.1:3142";' >> /etc/apt/apt.conf.d/01proxy \
#  && echo 'Acquire::HTTPS::Proxy "false";' >> /etc/apt/apt.conf.d/01proxy

# packages:
# - software-properties-common: add-apt-repository
# - imagemagick: display
RUN   apt-get update &&                   \
      apt-get -y install                  \
            realpath                      \
            curl                          \
            wget                          \
            realpath                      \
            git                           \
            python-pip                    \
            tar                           \
            bzip2                         \
            locales                       \
            ca-certificates               \
            software-properties-common    \     
            imagemagick