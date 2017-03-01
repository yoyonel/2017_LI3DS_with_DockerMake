WORKDIR /root
ENV HOME /root

ENV ROS_OVERLAY_WS /root/overlay_ws
ENV ROS_CATKIN_WS /root/catkin_ws

# RUN apt-get update \
# 	&& apt-get upgrade -y --fix-missing

ADD configure.sh .
ADD configure_overlay_ws.sh .
ADD rosdep.sh .
ADD configure_catkin_ws.sh . 
#
# RUN sh configure.sh .

ADD build.sh /root/build.sh
RUN chmod +x /root/build.sh
#
ADD prototype.launch /root/prototype.launch
ADD run.sh /root/run.sh
ADD edit.sh /root/edit.sh
RUN chmod +x /root/run.sh /root/edit.sh

# VOLUMES
# VOLUME ["${ROS_OVERLAY_WS}"]
# VOLUME ["${ROS_CATKIN_WS}"]

# CMD ["/root/run.sh"]
# ENTRYPOINT ["/ros_entrypoint.sh"]