#!/usr/bin/env bash

PATH_TO_PROJECT=$(realpath $1)

source env_for_project.sh $PATH_TO_PROJECT

echo_i "Deploy project from: ${GREEN}$PROJECT_IMAGE_TO"

cd deploy
. ./build_and_push.sh $PATH_TO_PROJECT
cd -

echo_i "${GREEN}${BOLD}Done"
