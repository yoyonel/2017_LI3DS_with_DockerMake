#!/bin/bash
set -e

source /entry-point.sh

# /opt/qt57/bin/qtcreator-wrapper
PYCHARM=`sh /pycharm-community-2016.3.3/bin/pycharm.sh`

if [ -z ${NEWUSER+x} ]; then
	echo 'WARN: No user was defined, defaulting to root.'
	echo 'WARN: PyCharm will save files as root:root.'
	echo '      To prevent this, start the container with -e NEWUSER=$USER'	

	LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 										\
		 	$PYCHARM
else
	# # The root user already exists, so we only need to do something if
	# # a user has been specified.
	useradd -s /bin/bash $NEWUSER

	echo "NEWUSER: $NEWUSER"

	echo "Add user for qtcreator"
	export uid=1000 gid=1000 && \
	mkdir -p /home/$NEWUSER && \
	# echo "$NEWUSER:x:${uid}:${gid}:$NEWUSER,,,:/home/$NEWUSER:/bin/zsh" >> /etc/passwd && \
	echo "$NEWUSER:x:${uid}:${gid}:$NEWUSER,,,:/home/$NEWUSER:/bin/bash" >> /etc/passwd && \
	echo "$NEWUSER:x:${uid}:" >> /etc/group && \
	echo "$NEWUSER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$NEWUSER && \
	chmod 0440 /etc/sudoers.d/$NEWUSER && \
	chown ${uid}:${gid} -R /home/$NEWUSER

	# point de volume: /home/.config
	# comme monté coté serveur, il appartient au root
	# On crée un lien symbolique vers le home du user
	# QtCreator va utiliser le `/home/$NEWUSER/.config` qui est lié symbolique
	# au volume monté `/home/.config` -> volume de config coté docker
	# if [ ! -d /home/$NEWUSER/.config ]; then
	# chown ${uid}:${gid} -R /home/.config
	# ln -s /home/.config /home/$NEWUSER/.config
	# fi

	# If you'd like to have PyCharm add your development folder
	# to the current project (i.e. in the sidebar at start), append
	# "-a /home/$NEWUSER/Documents" (without quotes) into the su -c command below.
	# Example: su $NEWUSER -c "/usr/src/sublime_text/sublime_text -w -a /home/$NEWUSER/Documents"
	su $NEWUSER -c "LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 \
		$PYCHARM"
fi