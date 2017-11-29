#!/bin/bash

xhost +

# 

docker run 	-d \
			--rm \
			--name pycharm \
			-h pycharm \
			-w /home/$USER \
			-e NEWUSER=$USER \
			-e DISPLAY=unix$DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix \
			-v $PWD:/home/$USER/development	\
			-v $HOME/.PyCharmCE2017.2:/root/.PyCharmCE2017.2 \
			project-dev_pycharm