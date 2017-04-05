#!/bin/sh

hg clone https://daniel_dube@bitbucket.org/daniel_dube/bagedit
cd bagedit
export ROS_PACKAGE_PATH=`pwd`:$ROS_PACKAGE_PATH
make -j
