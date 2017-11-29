#!/bin/bash

source bash_tools.sh

PROJECT_NAME=$1

echo " Project name: $PROJECT_NAME"

FILENAME_SHA_PROJECT=$1/sha256.txt
if [ -f $FILENAME_SHA_PROJECT ]; then
	PROJETSHA=$(cat $FILENAME_SHA_PROJECT)
	echo " SHA256 of project: $PROJETSHA"

	echo "clean host mountpoints ..."

	PATH_TO_VOLUME=$(realpath ../.volumes/pipeline/)
	PATH_TO_VOLUME_PROJECT="$PATH_TO_VOLUME/$PROJETSHA"
	#
	if [ -d $PATH_TO_VOLUME_PROJECT ]; then
		rm -rf $PATH_TO_VOLUME_PROJECT
		echo "remove directory: $PATH_TO_VOLUME_PROJECT"
	else
		echo "Can't find directory: $PATH_TO_VOLUME_PROJECT"
	fi
else
	echo "Can't find file: $FILENAME_SHA_PROJECT !"
fi

echo_i "${GREEN}${BOLD}Done"