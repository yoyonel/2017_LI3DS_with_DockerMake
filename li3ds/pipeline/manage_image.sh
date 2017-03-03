#!/bin/bash

# Montage du container
# urls: 
# - http://stackoverflow.com/questions/33416286/how-to-run-2-commands-with-docker-exec
# - http://stackoverflow.com/questions/3834839/how-to-escape-double-quote-inside-a-double-quote
# - http://stackoverflow.com/questions/7315587/bash-shortest-way-to-get-n-th-column-of-output

source env_for_project.sh $1

if docker images | grep -q $PROJECT_SHA256; then
	echo_i "Image already exist: ${RED}li3ds-prototype:$PROJECT_SHA256"
	./update_image.sh $1
else
	echo_i "Create Image: ${RED}li3ds-prototype:$PROJECT_SHA256"
	./create_image.sh $1
fi

echo_i "${GREEN}${BOLD}Done"