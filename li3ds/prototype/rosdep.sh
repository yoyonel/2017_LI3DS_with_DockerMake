#!/bin/bash

rosdep install \
	--default-yes \
	--from-paths $ROS_OVERLAY_WS \
	--ignore-src \
	--rosdistro indigo