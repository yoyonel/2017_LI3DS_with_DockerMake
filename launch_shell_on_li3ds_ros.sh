#!/bin/bash

# docker exec \
# 	-it \
# 	li3ds_ros \
# 	bash -c "source /ros_entrypoint.sh"

DOCKER_CONTAINER_NAME=li3ds-prototype
DOCKER_CONTAINER_NETWORK=li3ds-prototype

# url: https://docs.docker.com/engine/reference/run/
docker run \
	--rm \
	-ti \
	-e "ROS_HOSTNAME=li3ds_ros_shell" \
	-e "ROS_MASTER_URI=http://li3ds_ros:11311" \
	--network=$DOCKER_CONTAINER_NETWORK \
	--volumes-from li3ds_ros \
	$DOCKER_CONTAINER_NAME \
	bash

	# -v li3ds-prototype_catkin_ws:/root/catkin_ws \
	# -v li3ds-prototype_overlay_ws:/root/overlay_ws \
