#!/bin/bash

# echo $PATH
PROJECT_OVERLAY_WS_PATH=/root/project/overlay_ws
ROS_OVERLAY_WS=$PROJECT_OVERLAY_WS_PATH configure_overlay_ws.sh

change_owner.sh

# PROJET_SHA256=$( tree overlay_ws/ | sha256sum | awk '{print $1}');
PROJET_SHA256=$( tree ${PROJECT_OVERLAY_WS_PATH} | sha256sum | awk '{print $1}');

echo $PROJET_SHA256 > /root/project/sha256.txt;