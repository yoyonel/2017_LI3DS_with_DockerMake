#!/bin/bash

mkdir -p $ROS_CATKIN_WS
cd $ROS_CATKIN_WS

catkin init --workspace $ROS_OVERLAY_WS

# url: http://stackoverflow.com/questions/5767062/how-to-check-if-symlink-exists
if [ ! -L $ROS_OVERLAY_WS/src ]; then
	echo "Create symlink $ROS_OVERLAY_WS/src into $(realpath .)"
	ln -s $ROS_OVERLAY_WS/src .
else
	echo "Symlink $ROS_OVERLAY_WS/src already exist"
	ls -la $ROS_OVERLAY_WS/src
fi

catkin config --init