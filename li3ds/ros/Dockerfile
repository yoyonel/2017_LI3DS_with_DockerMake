USER root

ENV DEBIAN_FRONTEND=noninteractive

ADD apt.conf /etc/apt/apt.conf
ADD .gitconfig /root/.gitconfig

RUN apt-get -y update   			\
      && apt-get -y install 		\
      python-catkin-tools 			\
      python-rosinstall-generator 	\
      ros-indigo-rosserial-arduino 	\
      ros-indigo-rqt				\
      ros-indigo-rqt-common-plugins
      
