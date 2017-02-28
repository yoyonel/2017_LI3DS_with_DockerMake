WORKDIR /root
ENV HOME /root

ENV ROS_OVERLAY_WS /root/overlay_ws
ENV ROS_CATKIN_WS /root/catkin_ws

RUN mkdir -p ${ROS_OVERLAY_WS}/src
WORKDIR ${ROS_OVERLAY_WS}/src

RUN wstool init \
	&& wstool set ros_velodyne 					--confirm --update --git https://github.com/yoyonel/ros_velodyne.git 				\
	&& wstool set ros_velodyne_configuration 	--confirm --update --git https://github.com/yoyonel/ros_velodyne_configuration.git 	\
	&& wstool set sbg_ros_driver 				--confirm --update --git https://github.com/yoyonel/sbg_ros_driver.git 				\
	&& wstool set ros_arduino 					--confirm --update --git https://github.com/yoyonel/li3ds-ros_arduino.git 			\
	&& wstool update

WORKDIR ${ROS_OVERLAY_WS}

RUN apt-get update
RUN apt-get upgrade -y --fix-missing

RUN rosdep install \
	--default-yes \
	--from-paths ${ROS_OVERLAY_WS} \
	--ignore-src \
	--rosdistro indigo

WORKDIR ${ROS_CATKIN_WS}

RUN catkin init --workspace ${ROS_OVERLAY_WS} \
	&& ln -s ${ROS_OVERLAY_WS}/src . \
	&& catkin config --init \
	&& bash -c "source /opt/ros/indigo/setup.bash	\
	&& catkin build	|| true							\
	&& catkin build || true"

ADD build.sh /root/build.sh
RUN chmod +x /root/build.sh

#
ADD prototype.launch /root/prototype.launch
ADD run.sh /root/run.sh
ADD edit.sh /root/edit.sh
RUN chmod +x /root/run.sh /root/edit.sh

# VOLUMES
VOLUME ["${ROS_OVERLAY_WS}"]
VOLUME ["${ROS_CATKIN_WS}"]

CMD ["/root/run.sh"]
ENTRYPOINT ["/ros_entrypoint.sh"]