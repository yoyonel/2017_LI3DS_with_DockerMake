#!/usr/bin/env bash

source env.sh

# urls:
# - http://stackoverflow.com/questions/37281533/how-do-i-append-to-path-environment-variable-when-running-a-docker-container
docker run \
	-it --rm \
	--name $STEP2_CONTAINER_NAME \
	-v $QEMU_ARM_STATIC_HOST:/usr/bin/qemu-arm-static \
	-v $(realpath ./scripts):$WORKDIR/scripts \
	$STEP1_COMMIT_IMAGE_NAME \
	bash -c 'export PATH=$PATH:$WORKDIR/scripts && \
			install_li3ds_project.sh && \
			echo "Hit ctrl+p ctrl+q to suspend docker container" && \
			echo "and commit the new image: ./3_commit_new_image_li3ds.sh" && \
			bash'