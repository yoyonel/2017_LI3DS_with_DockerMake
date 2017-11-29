#!/bin/bash

source bash_tools.sh

PROJECT_OVERLAY_WS=/root/project/overlay_ws

# url: http://superuser.com/questions/821166/why-does-my-busybox-diff-report-common-subdirectories-for-every-file-pair
diff_with_project=$(diff -arq ${ROS_OVERLAY_WS}/src $PROJECT_OVERLAY_WS/src)

if [ $? -ne 0 ]; then
	echo_i "Difference between ${GREEN}${ROS_OVERLAY_WS}/src${CYAN} and ${GREEN}${PROJECT_OVERLAY_WS}/src${CYAN} detected !"

	# clean overlay_ws directory
	rm -rf ${ROS_OVERLAY_WS}/src

	echo_i "Copying overlay_ws for (hard) synchronization ..."
	cp -r /root/project/overlay_ws/src ~/overlay_ws/.
fi