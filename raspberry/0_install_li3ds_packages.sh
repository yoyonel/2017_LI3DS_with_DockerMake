#!/usr/bin/env bash

source env.sh

docker run \
	-it --rm \
	--name $STEP0_CONTAINER_NAME \
	-v $QEMU_ARM_STATIC_HOST:/usr/bin/qemu-arm-static \
	-v $(realpath ./scripts):$WORKDIR/scripts \
	$RESIN_IMAGE_NAME \
	bash -c '$WORKDIR/scripts/install_packages_for_li3ds.sh && \
			echo "Hit ctrl+p ctrl+q to suspend docker container" && \
			echo "and commit the new image: ./1_commit_new_image.sh" && \
			bash'
