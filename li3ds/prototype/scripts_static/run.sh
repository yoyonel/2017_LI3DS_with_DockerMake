#!/bin/bash
set -e

ROS_SETUP="${ROS_CATKIN_WS}/devel/setup.bash"

if [ -f $ROS_SETUP ]; then
	echo "Source setup ROS file: $ROS_SETUP"
	source $ROS_SETUP

	roslaunch /root/prototype.launch
else
	echo "Can't find setup ROS file: $ROS_SETUP"
fi