#!/bin/bash

source env_for_project.sh $1

function create_directory() {
	if [ ! -d $1 ]; then
		mkdir -p $1
		echo_i "point mount created: ${GREEN}${BOLD}$1"
	else
		echo_i "Directory already exist: ${RED}$1"
	fi	
}

create_directory $PATH_TO_OVERLAY_WS_VOLUME
create_directory $PATH_TO_CATKIN_WS_VOLUME

echo_i "${GREEN}${BOLD}Done"