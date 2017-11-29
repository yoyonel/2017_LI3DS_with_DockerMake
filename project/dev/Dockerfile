RUN apt-get update &&   \
    apt-get -y install	\
  		build-essential	\
  		clang

### CMAKE
ADD cmake-3.8.0-rc1.tar.Z /cmake-3.8.0-rc1.tar.Z
RUN tar xzvf /cmake-3.8.0-rc1.tar.Z
RUN cd cmake-3.8.0-rc1 && ./configure && make -j3 && make install
RUN rm -r /cmake-3.8.0-rc1.tar.Z cmake-3.8.0-rc1
