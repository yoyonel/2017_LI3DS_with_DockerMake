#!/bin/bash

set -e

cd $ROS_CATKIN_WS

catkin build --cmake-args -Wno-dev

cd -