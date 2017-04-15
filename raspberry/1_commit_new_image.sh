#!/usr/bin/env bash

source env.sh

docker commit \
	$(docker ps -aqf name=$STEP0_CONTAINER_NAME)	\
	$STEP1_COMMIT_IMAGE_NAME
