#!/bin/bash

source env_for_project.sh $1

export PROJECT_IMAGE_TO="172.20.250.99:5000/li3ds/deploy"

echo_i "Run deploy project from: ${GREEN}$PROJECT_IMAGE_TO"

################
# X11
################
xhost +local:root

OPTIONS_FOR_X11="    
			-e QT_X11_NO_MITSHM=1	 			\
			-e DISPLAY=$DISPLAY					\
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw	\
"

################
# ROS/CATKIN WORKSPACES
################
OPTIONS_FOR_ROS_WORKSPACES=" 								\
			-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
			-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
"

################
# Project link
################
OPTIONS_FOR_PROJECT=" 						\
			-v $(realpath $1):/root/project \
			"

################
# PROXY
################
OPTIONS_FOR_PROXY="
			-e FTP_PROXY=$FTP_PROXY 		\
			-e HTTPS_PROXY=$HTTPS_PROXY 	\
			-e HTTP_PROXY=$HTTP_PROXY 		\
			-e ftp_proxy=$ftp_proxy 		\
			-e http_proxy=$http_proxy 		\
			-e https_proxy=$https_proxy 	\
"

################
# LASER
################
OPTIONS_FOR_LASER="
			-p 11311:11311		\
      		-p 2368:2368/udp	\
      		-p 8308:8308/udp	\
"

################
# USB devices
################
OPTIONS_FOR_USB="
			--privileged					\
			-v /dev/bus/usb:/dev/bus/usb	\
"

################
# TOOLS SHELL
################
OPTIONS_FOR_ZSH="
			-v $(realpath $1/.zshrc):/root/.zshrc
"

OPTIONS_FOR_TMUXP="
			-v $(realpath $1/.tmuxp):/root/.tmuxp
"

################
# Container sur l'image du projet
# $OPTIONS_FOR_ROS_WORKSPACES						\
# $OPTIONS_FOR_X11								\
# $OPTIONS_FOR_PROJECT							\
# $OPTIONS_FOR_TMUXP								\
docker	run											\
	-it --rm										\
	--name li3ds-prototype_deploy					\
	-v $(realpath scripts):/root/scripts			\
	$OPTIONS_FOR_X11								\
	$OPTIONS_FOR_PROXY								\
	$OPTIONS_FOR_SSH								\
	$OPTIONS_FOR_USB								\
	$OPTIONS_FOR_LASER								\
	$OPTIONS_FOR_ZSH								\
	$PROJECT_IMAGE_TO		 						\
	bash -c "unset NEWUSER; tmux"

echo_i "${GREEN}${BOLD}Done"

################
# X11
################
xhost -local:root