#!/bin/bash

xhost +

source env_for_project.sh $1

docker-compose run li3ds-prototype_tmux

# docker-compose up

xhost -