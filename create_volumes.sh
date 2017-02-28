#!/bin/bash

#docker volume create --driver local --name li3ds_dev_overlay_ws
docker volume create \
	--driver local \
	--name li3ds-ros_overlay_ws

docker volume create \
	--driver local \
	--name li3ds-ros_catkin_ws

# Manque le plugin ...
# docker volume create \
# 	--name  li3ds-ros_overlay_ws \
# 	-o mountpoint=$(realpath li3ds/.volumes/.) \
# 	-d local-persist 

# docker volume create \
# 	--name  li3ds-ros_catkin_ws \
# 	-o mountpoint=$(realpath li3ds/.volumes/.) \
# 	-d local-persist 