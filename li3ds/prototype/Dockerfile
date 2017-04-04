# installation de docker (pour accéder au docker de l'host via un mapping)
RUN wget -qO- https://get.docker.com/ | sh

ENV GOSU_VERSION 1.10
# && rm -rf /var/lib/apt/lists/*
RUN set -x \
    && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget \
    && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
    && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
    && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc" \
    && export GNUPGHOME="$(mktemp -d)" \
    && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
    && rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && gosu nobody true 
    # \ && apt-get purge -y --auto-remove ca-certificates wget

# ha.pool.sks-keyservers.net

WORKDIR /root
ENV HOME /root

ENV ROS_OVERLAY_WS ${HOME}/overlay_ws
ENV ROS_CATKIN_WS ${HOME}/catkin_ws

# RUN apt-get update \
# 	&& apt-get upgrade -y --fix-missing

# ADD configure.sh .
# ADD configure_overlay_ws.sh .
# ADD rosdep.sh .
# ADD configure_catkin_ws.sh . 
# #
# # RUN sh configure.sh .

# ADD build.sh /root/build.sh
# RUN chmod +x /root/build.sh
# #
# ADD prototype.launch /root/prototype.launch
# ADD run.sh /root/run.sh
# ADD change_owner.sh /root/change_owner.sh
# RUN chmod +x /root/run.sh /root/change_owner.sh

COPY scripts_static scripts
RUN chmod +x scripts/*.sh
# RUN mkdir scripts
# url: http://stackoverflow.com/questions/27093612/in-a-dockerfile-how-to-update-path-environment-variable
ENV PATH="/root/scripts:${PATH}"

# Pre-create directories for workspaces (Overlay & Catkin)
RUN mkdir -p \
		${ROS_OVERLAY_WS} \
		${ROS_CATKIN_WS}

# # VOLUMES
# VOLUME ["${ROS_OVERLAY_WS}"]
# VOLUME ["${ROS_CATKIN_WS}"]

# COPY docker-entrypoint.sh .
# RUN chmod +x docker-entrypoint.sh

# CMD ["/root/docker-entrypoint.sh"]
# ENTRYPOINT ["/root/docker-entrypoint.sh"]

# COPY docker-entrypoint.sh /usr/local/bin/entrypoint.sh
# RUN chmod +x /usr/local/bin/entrypoint.sh
# ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
# CMD ["/bin/bash"]