#!/bin/bash

set -e

echo "NEWUSER: $NEWUSER"

if [ -z ${NEWUSER+x} ]; then
	echo 'WARN: No user was defined, defaulting to root.'
	# echo 'WARN: Sublime will save files as root:root.'
	echo '      To prevent this, start the container with -e NEWUSER=$USER'
	NEWUSER=root
else
	# The root user already exists, so we only need to do something if
	# a user has been specified.
	useradd -s /bin/bash $NEWUSER
	# If you'd like to have Sublime Text add your development folder
	# to the current project (i.e. in the sidebar at start), append
	# "-a /home/$NEWUSER/Documents" (without quotes) into the su -c command below.
	# Example: su $NEWUSER -c "/usr/src/sublime_text/sublime_text -w -a /home/$NEWUSER/Documents"
	# su $NEWUSER -c "LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 /usr/src/sublime_text/sublime_text -w"
fi

chown -R --no-dereference $NEWUSER:$NEWUSER ${ROS_OVERLAY_WS}

chmod -R 700 ${ROS_CATKIN_WS}
chown -R --no-dereference $NEWUSER:$NEWUSER ${ROS_CATKIN_WS}

# ln -fs ${ROS_OVERLAY_WS}/* 	/workspace/overlay
# ln -fs ${ROS_CATKIN_WS}/*	/workspace/catkin
