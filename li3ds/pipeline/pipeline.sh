#!/bin/bash

source bash_tools.sh

PROJECT_NAME=$1

echo_i "Project name: ${RED}$PROJECT_NAME"

./create_volumes.sh $PROJECT_NAME

./generate_sha256.sh $PROJECT_NAME

./manage_image.sh $PROJECT_NAME

./build_image.sh $PROJECT_NAME

echo_i "${GREEN}${BOLD}Done"