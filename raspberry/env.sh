#!/usr/bin/env bash

source scripts/env.sh

export RESIN_IMAGE_NAME="spmaniato/resin-raspbian-ros-indigo-qemu"
export QEMU_ARM_STATIC_HOST=/usr/bin/qemu-arm-static

# step 0
export STEP0_CONTAINER_NAME="0_resin-raspbian-ros-indigo-qemu"

# step 1
export STEP1_COMMIT_IMAGE_NAME="atty/qemu_for_li3ds"

# step 2
export STEP2_COMMIT_IMAGE_NAME="atty/li3ds:rpi"
export STEP2_CONTAINER_NAME="2_qemu_for_li3ds"

# step 4
export STEP4_REGISTRY_IP="192.168.0.13:5000"

# step 5

# step 6
export STEP6_RPI_IP=pi@192.168.0.28
export STEP6_RPI_DEPLOY_PATH=/home/pi/Prog/2017_LI3DS_with_DockerMake/li3ds/pipeline/project1/build_crosscompile
