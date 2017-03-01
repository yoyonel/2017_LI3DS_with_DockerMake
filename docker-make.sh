#!/bin/bash

if [ "$VIRTUAL_ENV" == 	"$PWD/venv" ]; then
	./DockerMake/docker-make.py $@
else
	echo "no virtualenv (activate) detected !"
	
	if [ -d venv ]; then
		echo "activate virtualenv: venv"
		source venv/bin/activate
	else
		echo "create virtualenv: venv with python2.7"
		virtualenv --no-site-packages -p /usr/bin/python2.7 venv
		echo "activate virtualenv: venv"
		source venv/bin/activate
		echo "-> install requirements"
		pip install -r DockerMake/requirements.txt
	fi

	./DockerMake/docker-make.py $@

	deactivate
fi