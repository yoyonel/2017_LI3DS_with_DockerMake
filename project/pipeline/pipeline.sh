#!/bin/bash

source bash_tools.sh

PROJECT_NAME=$1

echo_i "Project name: ${RED}$PROJECT_NAME"

./validate_project.sh $1
if [ $? -ge 0 ]; then
	# Generation du SHA du projet
	./generate_sha256.sh $PROJECT_NAME

	# Avec le SHA du projet, 
	# on peut construire des hosts mountpoints pour les volumes
	./create_volumes.sh $PROJECT_NAME

	./manage_image.sh $PROJECT_NAME

	./build_image.sh $PROJECT_NAME
fi

echo_i "${GREEN}${BOLD}Done"