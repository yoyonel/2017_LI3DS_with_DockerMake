#!/bin/bash

set -e

if [ -z ${NEWUSER+x} ]; then
	echo 'WARN: No user was defined, defaulting to root.'
	# echo 'WARN: Sublime will save files as root:root.'
	echo '      To prevent this, start the container with -e NEWUSER=$USER'
	# LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 /usr/src/sublime_text/sublime_text -w
else
	# The root user already exists, so we only need to do something if
	# a user has been specified.
	useradd -s /bin/bash $NEWUSER
	# If you'd like to have Sublime Text add your development folder
	# to the current project (i.e. in the sidebar at start), append
	# "-a /home/$NEWUSER/Documents" (without quotes) into the su -c command below.
	# Example: su $NEWUSER -c "/usr/src/sublime_text/sublime_text -w -a /home/$NEWUSER/Documents"
	# su $NEWUSER -c "LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 /usr/src/sublime_text/sublime_text -w"
	sudo -u $NEWUSER
fi

mkdir -p $ROS_OVERLAY_WS/src
cd $ROS_OVERLAY_WS/src

wstool init \
	&& wstool set ros_velodyne 					--confirm --update --git https://github.com/yoyonel/ros_velodyne.git 				\
	&& wstool set ros_velodyne_configuration 	--confirm --update --git https://github.com/yoyonel/ros_velodyne_configuration.git 	\
	&& wstool set sbg_ros_driver 				--confirm --update --git https://github.com/yoyonel/sbg_ros_driver.git 				\
	&& wstool set ros_arduino 					--confirm --update --git https://github.com/yoyonel/li3ds-ros_arduino.git 			\
	&& wstool update

apt-get update
apt-get upgrade -y --fix-missing

cd $ROS_CATKIN_WS

rosdep install \
	--default-yes \
	--from-paths $ROS_OVERLAY_WS \
	--ignore-src \
	--rosdistro indigo

catkin init --workspace $ROS_OVERLAY_WS \
	&& ln -s $ROS_OVERLAY_WS/src . \
	&& catkin config --init \
	&& bash -c "source /opt/ros/indigo/setup.bash	\
	&& catkin build	|| true							\
	&& catkin build || true"