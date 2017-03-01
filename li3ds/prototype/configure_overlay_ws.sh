#!/bin/bash

mkdir -p $ROS_OVERLAY_WS/src

cd $ROS_OVERLAY_WS/src

wstool init \
	&& wstool set ros_velodyne 					--confirm --update --git https://github.com/yoyonel/ros_velodyne.git 				\
	&& wstool set ros_velodyne_configuration 	--confirm --update --git https://github.com/yoyonel/ros_velodyne_configuration.git 	\
	&& wstool set sbg_ros_driver 				--confirm --update --git https://github.com/yoyonel/sbg_ros_driver.git 				\
	&& wstool set ros_arduino 					--confirm --update --git https://github.com/yoyonel/li3ds-ros_arduino.git 			\
	&& wstool update
