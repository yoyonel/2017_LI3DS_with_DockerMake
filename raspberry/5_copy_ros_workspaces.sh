#!/usr/bin/env bash

source env.sh
source scripts/bash_tools.sh

echo_i "Copy directories:"
echo_i "- ROS_CATKIN_WS: $ROS_CATKIN_WS"
echo_i "- ROS_OVERLAY_WS: $ROS_OVERLAY_WS"
echo_i "from container: $STEP2_CONTAINER_NAME to host ..."
docker cp $STEP2_CONTAINER_NAME:$ROS_CATKIN_WS .
docker cp $STEP2_CONTAINER_NAME:$ROS_OVERLAY_WS .

echo_i "Tar.gz of directories ..."
tar -zcvf catkin_ws.tar.gz catkin_ws
tar -zcvf overlay_ws.tar.gz overlay_ws
#
rm -rf catkin_ws overlay_ws