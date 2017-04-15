#!/usr/bin/env bash

source env.sh

docker commit \
	$(docker ps -aqf name=$STEP2_CONTAINER_NAME)	\
	$STEP2_COMMIT_IMAGE_NAME
