#!/bin/bash

# set -e 

cp -r /root/project/overlay_ws /root/.

rosdep.sh;

configure_catkin_ws.sh

PROJECT_SHA256=$(cat /root/project/sha256.txt)

docker commit li3ds-prototype_step1 li3ds-prototype:$PROJECT_SHA256
echo "docker commit li3ds-prototype_step1 li3ds-prototype:$PROJECT_SHA256 [done]"
#