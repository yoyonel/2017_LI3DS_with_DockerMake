#!/usr/bin/env bash

export WORKDIR="/root"

export ROS_WORKSPACE="$WORKDIR"
export ROS_OVERLAY_WS=$ROS_WORKSPACE/overlay_ws
export ROS_CATKIN_WS=$ROS_WORKSPACE/catkin_ws

export LI3DS_ROSINSTALL_URL=https://raw.githubusercontent.com/yoyonel/2017_LI3DS_with_DockerMake/master/li3ds/pipeline/project1/.rosinstall
