#!/bin/bash

xhost +

docker run 	-d \
			--rm \
			--name sublime-text \
			-h sublime-text \
			-w /home/$USER \
			-e NEWUSER=$USER \
			-e DISPLAY=unix$DISPLAY \
			-v /tmp/.X11-unix:/tmp/.X11-unix \
			-v $PWD:/home/$USER/development \
			-v $HOME/.config/sublime-text-3/:/home/$USER/.config/sublime-text-3 \
			project-tools_sublimetext3