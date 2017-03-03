#!/bin/bash

if [ -d ${ROS_OVERLAY_WS}/src ]; then
	cd ${ROS_OVERLAY_WS}/src;
else
	echo "Cant find directory: ${ROS_OVERLAY_WS}/src"
	mkdir -p ${ROS_OVERLAY_WS}/src
	
	PROJECT_SRC_PATH=/root/project/overlay_ws/src

	if [ -f $PROJECT_SRC_PATH/.rosinstall ]; then
		echo "Copy $PROJECT_SRC_PATH/.rosinstall to ${ROS_OVERLAY_WS}/src"
		cp $PROJECT_SRC_PATH/.rosinstall ${ROS_OVERLAY_WS}/src/.rosinstall
	else
		echo "Can't update source ! (exit)"
		exit -1;
	fi
fi

wstool update;