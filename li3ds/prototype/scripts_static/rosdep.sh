#!/bin/bash

source bash_tools.sh

ROSDEP_CHECK=$(rosdep check \
	--from-paths $ROS_OVERLAY_WS \
	--rosdistro indigo)

ROSDEP_SATISFIED="All system dependencies have been satisified"

echo_i "Check dependancies for src in: ${RED}$ROS_OVERLAY_WS"

if [ "$ROSDEP_CHECK" == "$ROSDEP_SATISFIED" ]; then
	echo_i "${GREEN}${BOLD}$ROSDEP_SATISFIED"
else
	echo_i "New dependancies detected !"
	echo "${GREEN}${BOLD}$ROSDEP_CHECK"

	rosdep install \
		--default-yes \
		--from-paths $ROS_OVERLAY_WS \
		--ignore-src \
		--rosdistro indigo
fi