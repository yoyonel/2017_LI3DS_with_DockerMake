# On herite de l'image de compilation du projet
FROM li3ds-prototype:8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c

# Copie des ROS Workspaces (sources et resultats de compilation)
COPY overlay /root/overlay_ws
COPY catkin /root/catkin_ws

WORKDIR /root/project

RUN mkdir -p /root/project

COPY prototype.launch prototype.launch
COPY LI3DS.perspective LI3DS.perspective

COPY .tmuxp /root/.tmuxp

COPY run.sh	run.sh
RUN chmod +x run.sh

# PCL 
# - pour pcl_viewer
# - pour la conversion point_cloud -> pcd [ROS]
RUN apt-get install ros-indigo-perception-pcl

RUN sudo -EH add-apt-repository ppa:v-launchpad-jochen-sprickerhof-de/pcl;	\
	apt-get update; \
	apt-get install libpcl-all

COPY convert_bag_to_pcd.sh convert_bag_to_pcd.sh
RUN chmod +x convert_bag_to_pcd.sh

ENTRYPOINT ["/root/project/run.sh"]