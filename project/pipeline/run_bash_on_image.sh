#!/bin/bash

source env_for_project.sh $1

echo_i "Build project from: ${GREEN}$PROJECT_IMAGE_TO"

xhost +local:root

OPTIONS_FOR_DOCKER="
			-v /var/run/docker.sock:/var/run/docker.sock	\
"

OPTIONS_FOR_X11="    
			-e QT_X11_NO_MITSHM=1	 			\
			-e DISPLAY=$DISPLAY					\
            -v /tmp/.X11-unix:/tmp/.X11-unix:rw	\
"

if [ ! -d $1/.config ]; then
	mkdir -p $1/.config
fi
OPTIONS_FOR_QTCREATOR="
            -v $(realpath $1/.config):/root/.config	\
            --security-opt seccomp=unconfined 		\
            "

# Configs JAVA
# useful for PyCharm settings (for example)
if [ ! -d $1/.java ]; then
	mkdir -p $1/.java
fi
OPTIONS_FOR_JAVA="
			-v $(realpath $1/.java):/root/.java 	\
"

# PyCharm (2016.3)
PYCHARM_CONFIGS=.PyCharmCE2016.3
if [ ! -d $1/$PYCHARM_CONFIGS ]; then
	mkdir -p $1/$PYCHARM_CONFIGS
fi
OPTIONS_FOR_PYCHARM="
			-v $(realpath $1/$PYCHARM_CONFIGS):/root/$PYCHARM_CONFIGS	\
"

# ROS/CATKIN WORKSPACES
OPTIONS_FOR_ROS_WORKSPACES=" 								\
			-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws 	\
			-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws 	\
"

OPTIONS_FOR_PROJECT=" 						\
			-v $(realpath $1):/root/project \
			"

OPTIONS_FOR_PROXY="
			-e FTP_PROXY=$FTP_PROXY 		\
			-e HTTPS_PROXY=$HTTPS_PROXY 	\
			-e HTTP_PROXY=$HTTP_PROXY 		\
			-e ftp_proxy=$ftp_proxy 		\
			-e http_proxy=$http_proxy 		\
			-e https_proxy=$https_proxy 	\
"

OPTIONS_FOR_SSH="
			-v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK)	\
			-e SSH_AUTH_SOCK=$SSH_AUTH_SOCK							\
"

OPTIONS_FOR_LASER="
			-p 11311:11311		\
      		-p 2368:2368/udp	\
      		-p 8308:8308/udp	\
"

OPTIONS_FOR_USB="
			--privileged					\
			-v /dev/bus/usb:/dev/bus/usb	\
"

OPTIONS_FOR_ZSH="
			-v $(realpath $1/.zshrc):/root/.zshrc
"

OPTIONS_FOR_TMUXP="
			-v $(realpath $1/.tmuxp):/root/.tmuxp
"

#hostname="$(hostname -i)"
# hostname="MAC1201W008-LINUX"
# OPTIONS_FOR_SOUND="
#     -e PULSE_SERVER=tcp:$hostname:4713         \
#     -e PULSE_COOKIE=/run/pulse/cookie               \
#     -v cookie:/run/pulse/cookie                     \
# "
function EPHYMERAL_PORT(){
    LPORT=32768;
    UPORT=60999;
    while true; do
        MPORT=$[$LPORT + ($RANDOM % $UPORT)];
        (echo "" >/dev/tcp/127.0.0.1/${MPORT}) >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo $MPORT;
            return 0;
        fi
    done
}
PULSE_PORT=EPHYMERAL_PORT
PULSE_MODULE_ID=$(pactl load-module module-native-protocol-tcp port=$PULSE_PORT auth-ip-acl=172.17.42.1/16)
OPTIONS_FOR_SOUND="
	-e PULSE_SERVER=tcp:172.17.42.1:$PULSE_PORT
"

# Container sur l'image du projet
docker	run											\
	-it --rm										\
	--name li3ds-prototype_step2					\
	-v $(realpath scripts):/root/scripts			\
	$OPTIONS_FOR_X11								\
	$OPTIONS_FOR_DOCKER								\
	$OPTIONS_FOR_ROS_WORKSPACES						\
	$OPTIONS_FOR_QTCREATOR							\
	$OPTIONS_FOR_JAVA								\
	$OPTIONS_FOR_PYCHARM							\
	$OPTIONS_FOR_PROJECT							\
	$OPTIONS_FOR_PROXY								\
	$OPTIONS_FOR_SSH								\
	$OPTIONS_FOR_USB								\
	$OPTIONS_FOR_LASER								\
	$OPTIONS_FOR_ZSH								\
	$OPTIONS_FOR_TMUXP								\
    $OPTIONS_FOR_SOUND                              \
	$PROJECT_IMAGE_TO		 						\
	bash -c "unset NEWUSER; tmux"

echo_i "${GREEN}${BOLD}Done"

xhost -local:root
