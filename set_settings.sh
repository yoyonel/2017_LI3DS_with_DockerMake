#!/bin/bash

if [ ! -f buildargs.yml ]; then
	touch buildargs.yml
fi

if [ ! -f li3ds/ros/apt.conf ]; then
	if [ -f /etc/apt/apt.conf ]; then
		cp /etc/apt/apt.conf li3ds/ros/apt.conf
	else
		touch li3ds/ros/apt.conf
	fi
fi

if [ ! -f li3ds/ros/.gitconfig ]; then
	if [ -f ~/.gitconfig ]; then
		cp ~/.gitconfig li3ds/ros/.gitconfig
	else
		touch li3ds/ros/.gitconfig
	fi
fi