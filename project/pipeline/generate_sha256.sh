#!/bin/bash

source bash_tools.sh

source env_for_project.sh $1

# Génération d'un SHA256 basé sur l'arborescence du workspace des sources (overlay_ws)
echo_i "Project name: ${RED}${BOLD}$1"

# url: http://wiki.ros.org/wstool
# => Merge in Additional rosinstall Files
# TODO: utiliser directement des fichiers .rosinstall
# pour mettre à jour (ajouter) les sources du projet !
# $ wstool merge -t src PATH_TO_ROSINSTALL_FILE.rosinstall

echo_i "Generate SHA256 ..."
# docker	run 	\
# 		-it --rm	\
# 		--name li3ds-prototype_step1	\
# 		-v $(realpath $1):/root/project/ \
# 		-e NEWUSER=$USER \
# 		li3ds-prototype_docker \
# 		bash -c \
# 			'
# 			ROS_OVERLAY_WS=/root/project/overlay_ws
# 			sh /root/configure_overlay_ws.sh; \
# 			sh /root/change_owner.sh; \
# 			PROJET_SHA256=$(tree overlay_ws/ | sha256sum | awk '\''{print $1}'\''); \
# 			echo $PROJET_SHA256 > /root/project/sha256.txt;
# 			'

# -v $PATH_TO_OVERLAY_WS_VOLUME:/root/overlay_ws \

(env | grep proxy) > env.list

# -e NEWUSER=$USER 		\
docker	run 	\
		-it --rm	\
		--name li3ds-prototype_generate_sha256	\
		-v $(realpath scripts):/root/scripts \
		-v $(realpath $1):/root/project/ \
		--env-file env.list 	\
		li3ds-prototype_docker 	\
		generate_sha256.sh
		
rm env.list

PROJET_SHA256=$(cat $1/sha256.txt)

echo_i "SHA256 generate: ${GREENBOLD}$PROJET_SHA256"

echo_i "${GREENBOLD}Done"