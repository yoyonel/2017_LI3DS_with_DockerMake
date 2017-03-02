#!/bin/bash

mkdir -p $ROS_OVERLAY_WS/src

cd $ROS_OVERLAY_WS/src

if [ ! -f .rosinstall ]; then
	wstool init
fi

# wstool set ros_velodyne 				--confirm --update --git https://github.com/yoyonel/ros_velodyne.git
# wstool set ros_velodyne_configuration 	--confirm --update --git https://github.com/yoyonel/ros_velodyne_configuration.git
# wstool set sbg_ros_driver 				--confirm --update --git https://github.com/yoyonel/sbg_ros_driver.git
# wstool set ros_arduino 					--confirm --update --git https://github.com/yoyonel/li3ds-ros_arduino.git
if [ -f /root/project/wstools.txt ]; then
	cat /root/project/wstools.txt | while read line
	do
		name=$(echo $line | awk '{print $1}')
		repo=$(echo $line | awk '{print $2}')
		#
		wstool set $name --confirm --update --git $repo
	done
	wstool update
fi