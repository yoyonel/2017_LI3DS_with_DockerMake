#!/usr/bin/env bash

source bash_tools.sh
source env.sh

# workspace
echo_i "Create directory: $ROS_WORKSPACE"
mkdir -p $ROS_WORKSPACE

## overlay_ws
echo_i "Create directory: $ROS_OVERLAY_WS/src"
mkdir -p $ROS_OVERLAY_WS/src
#
cd $ROS_OVERLAY_WS/src

# .rosinstall
echo_i "Download .rosinstall: $LI3DS_ROSINSTALL_URL"
wget $LI3DS_ROSINSTALL_URL -O .rosinstall

# get sources
echo_i "wstool update ..."
wstool update

## catkin_ws
echo_i "Create directory: $ROS_CATKIN_WS"
mkdir -p $ROS_CATKIN_WS

cd $ROS_CATKIN_WS

if [ ! -d .catkin_tools ]; then
	catkin init --workspace $ROS_OVERLAY_WS
fi

mkdir -p src

echo_i "Create symlink $ROS_OVERLAY_WS/src into $(realpath src/.)"
ln -fs $ROS_OVERLAY_WS/src src/.

catkin config --init

# rosdep for li3ds project
apt-get update

# installation des dépendances restantes 
# (dans notre cas: 'python-pyaudio')
rosdep install \
		--default-yes \
		--from-paths $ROS_OVERLAY_WS \
		--ignore-src \
		--rosdistro indigo

# build
catkin build --cmake-args -Wno-dev
