#!/bin/bash

# set -e

if [ ! -L $ROS_CATKIN_WS/src ]; then
	echo "Create symlink $ROS_OVERLAY_WS/src into $ROS_CATKIN_WS/src"
	ln -s $ROS_OVERLAY_WS/src .
fi

cd $ROS_CATKIN_WS

# url: http://wiki.ros.org/ROS/EnvironmentVariables#ROS_PARALLEL_JOBS
export ROS_PARALLEL_JOBS='-j3 -l2'

catkin build --cmake-args -Wno-dev

cd -