#!/bin/bash

source bash_tools.sh

# url: http://wiki.ros.org/wstool

PATH_TO_SRC=$ROS_OVERLAY_WS/src

mkdir -p $PATH_TO_SRC
cd $PATH_TO_SRC

if [ ! -f .rosinstall ]; then
	wstool init .
else
	echo_i "wstool already initialized !"
fi

PROJECT_PATH=/root/project
if [ -f $PROJECT_PATH/.rosinstall ]; then
	echo_i "Found .rosinstall file in ${RED}$PROJECT_PATH/"
	# cat $PROJECT_PATH/.rosinstall

	# url: http://stackoverflow.com/questions/12736013/comparison-function-that-compares-two-text-files-in-unix
	if ! cmp -s .rosinstall $PROJECT_PATH/.rosinstall; then
		echo_i ".rosinstall are different, try to merge workspace"
		echo_i "Show differences:"
		ROSINSTALLS_DIFF=$(diff .rosinstall $PROJECT_PATH/.rosinstall)
		echo "${GREEN}${BOLD}$ROSINSTALLS_DIFF"

		# Merge les rosinstall et update la version dans projet
		wstool merge -t . $PROJECT_PATH/.rosinstall \
			&& cp .rosinstall $PROJECT_PATH/.rosinstall; \
			echo_i "Update rosinstall: ${GREENBOLD}$PROJECT_PATH/.rosinstall"
	else
		echo_i ".rosinstall are the same, skip update"
	fi
else
	echo_i "Can't found .rosinstall file in ${GREEN}$PROJECT_PATH/"
fi

echo_i ".rosinstall used for configuration: ${GREENBOLD}$(realpath .rosinstall)"
cat .rosinstall

wstool update