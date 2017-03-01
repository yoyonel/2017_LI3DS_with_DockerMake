#!/bin/bash

mkdir -p $ROS_CATKIN_WS
cd $ROS_CATKIN_WS

catkin init --workspace $ROS_OVERLAY_WS

ln -s $ROS_OVERLAY_WS/src .

catkin config --init