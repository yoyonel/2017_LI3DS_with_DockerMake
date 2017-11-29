#!/bin/bash

QTCREATOR_OPTIONS="
	-noload Welcome 	\
	-noload QmlDesigner \
	-noload QmlProfiler
	"
# QTCREATOR_OPTIONS+="-stylesheet=~/.config/QtProject/qtcreator/styles/stylesheet.css"

LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 /usr/bin/qtcreator $QTCREATOR_OPTIONS
	
	