#!/bin/bash

source bash_tools.sh

if [ -d $1 ]; then
	VALIDATE_ROSINSTALL="$1/.rosinstall"
	VALIDATE_OVERLAY_WS="$1/overlay_ws/src/.rosinstall"

	if [ -f $VALIDATE_ROSINSTALL ]; then
		if [ -f $VALIDATE_OVERLAY_WS ]; then
			echo_i "Project configured !"
			echo_i "${GREEN}Done"
			exit 0
		else
			echo_i "Can't find: ${GREEN}${VALIDATE_OVERLAY_WS}"
			echo_w "Warning"
			exit 1
		fi
	else
		echo_i "Can't find: ${VALIDATE_ROSINSTALL}"
		echo_c "FAILED"
		exit -1
	fi
else
	echo_i "Directory doesn't exist: ${GREEN}$1"
	echo_c "FAILED"
	exit -1
fi