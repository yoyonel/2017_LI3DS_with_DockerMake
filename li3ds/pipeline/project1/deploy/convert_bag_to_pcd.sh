#!/bin/sh
ROS_TOPIC=/Laser/velodyne_points

rosrun pcl_ros bag_to_pcd $1 $ROS_TOPIC $2