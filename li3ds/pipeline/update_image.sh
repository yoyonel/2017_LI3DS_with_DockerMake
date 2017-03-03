#!/bin/bash

# urls:
# - https://www.cyberciti.biz/faq/bash-scripting-using-awk/

source env_for_project.sh $1

# PROJECT_IMAGE=$PROJECT_IMAGE_TO_BASE:$PROJECT_SHA256

echo_w "Try to update: ${RED}$PROJECT_IMAGE_TO"

# TODO: gérer la modification du contexte de l'image
# par exemple si modification d'un package.xml, ça
# influencera rosdep qui installera (potentiellement)
# de nouveaux paquets apt pour satisfaire les dépendances.
# Il faut construire un script pour complexe et astucieux à ce niveau !
docker	run 	\
	-it --rm	\
	--name li3ds-prototype_step1	\
	-v $(realpath $1):/root/project/ \
	-v $(realpath scripts):/root/scripts \
	-v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws \
	-v $PATH_TO_CATKIN_WS_VOLUME:/root/catkin_ws \
	-e NEWUSER=$USER \
	$PROJECT_IMAGE_TO \
	update_image.sh

if [ ! $? ]; then
	echo_i "Image updated: ${GREEN}${BOLD}$PROJECT_IMAGE_TO"
fi
echo_i "${GREEN}${BOLD}Done"