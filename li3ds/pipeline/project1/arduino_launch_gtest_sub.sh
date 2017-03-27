#!/bin/bash
export NMEA_PARSER_PATH=/root/catkin_ws/devel/lib/nmea/
echo "NMEA_PARSER_PATH set to $NMEA_PARSER_PATH"
rostest ros_arduino ros_arduino_sub.test
