#!/bin/bash

set -e

cd $ROS_CATKIN_WS

if [ ! -L $ROS_CATKIN_WS/src ]; then
	echo "Create symlink $ROS_OVERLAY_WS/src into $ROS_CATKIN_WS/src"
	ln -s $ROS_OVERLAY_WS/src .
fi

catkin build --cmake-args -Wno-dev

cd -