#!/bin/bash

# Source ROS
source /ros_entrypoint.sh

# Source catkin installation
if [ -n "$ZSH_VERSION" ]; then
	if [ -f ${ROS_CATKIN_WS}/devel/setup.zsh ]; then
		source ${ROS_CATKIN_WS}/devel/setup.zsh;
	else
		echo "Can't source the catkin_ws !"
	fi
elif [ -n "$BASH_VERSION" ]; then
	if [ -f ${ROS_CATKIN_WS}/devel/setup.bash ]; then
		source ${ROS_CATKIN_WS}/devel/setup.bash;
	else
		echo "Can't source the catkin_ws !"
	fi
else
   echo "Can't source the catkin_ws !"
fi

