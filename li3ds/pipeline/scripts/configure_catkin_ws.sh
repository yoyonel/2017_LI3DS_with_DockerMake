#!/bin/bash

source bash_tools.sh

mkdir -p $ROS_CATKIN_WS
cd $ROS_CATKIN_WS

if [ ! -d .catkin_tools ]; then
	catkin init --workspace $ROS_OVERLAY_WS
fi

mkdir -p src

echo_i "Create symlink $ROS_OVERLAY_WS/src into $(realpath src/.)"
ln -fs $ROS_OVERLAY_WS/src src/.

catkin config --init