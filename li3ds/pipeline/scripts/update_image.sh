#!/bin/bash

source bash_tools.sh

if [ ! -d ${ROS_OVERLAY_WS}/src ]; then
	echo_i "Cant find directory: ${RED}${ROS_OVERLAY_WS}/src"
	mkdir -p ${ROS_OVERLAY_WS}/src
	
	PROJECT_SRC_PATH=/root/project/overlay_ws/src

	if [ -f $PROJECT_SRC_PATH/.rosinstall ]; then
		echo_i "Copy ${GREEN}$PROJECT_SRC_PATH/.rosinstall${CYAN} to ${GREEN}${ROS_OVERLAY_WS}/src"
		cp $PROJECT_SRC_PATH/.rosinstall ${ROS_OVERLAY_WS}/src/.rosinstall
	else
		echo_i "Can't update source ! (exit)"
		exit -1;
	fi
fi

cd ${ROS_OVERLAY_WS}/src;

wstool update;