#!/usr/bin/env bash

LI3DS_ROS_PACKAGES="ros-indigo-rosserial-python ros-indigo-pcl-ros \
	ros-indigo-diagnostic-updater ros-indigo-nmea-msgs \
	ros-indigo-angles ros-indigo-dynamic-reconfigure \
	ros-indigo-rosserial-arduino ros-indigo-rqt \
	ros-indigo-rqt-common-plugins"

LI3DS_PACKAGES="$LI3DS_ROS_PACKAGES libpcap-dev libyaml-cpp-dev"
#LI3DS_PACKAGES="libpcap-dev libyaml-cpp-dev"

apt-get update
apt-get install -y $LI3DS_PACKAGES
rm -rf /var/lib/apt/lists/*
