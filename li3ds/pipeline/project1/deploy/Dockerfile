# On herite de l'image de compilation du projet
FROM li3ds-prototype:8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c

# Copie des ROS Workspaces (sources et resultats de compilation)
COPY overlay /root/overlay_ws
COPY catkin /root/catkin_ws

WORKDIR /root/project

RUN mkdir -p /root/project
COPY prototype.launch prototype.launch
COPY run.sh	run.sh
COPY LI3DS.perspective LI3DS.perspective
COPY .tmuxp .tmuxp

RUN chmod +x run.sh

ENTRYPOINT ["/root/project/run.sh"]