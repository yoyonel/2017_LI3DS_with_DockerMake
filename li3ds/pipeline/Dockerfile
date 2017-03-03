# Pour générer un sha du projet
RUN apt-get install -y tree 

USER root
WORKDIR /root

COPY scripts /root/scripts

# set env !
ENV ROS_OVERLAY_WS ${HOME}/overlay_ws
ENV ROS_CATKIN_WS ${HOME}/catkin_ws

RUN mkdir -p ${ROS_OVERLAY_WS} ${ROS_CATKIN_WS}

ENV PATH $PATH:${HOME}/scripts

# COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["/bin/bash"]