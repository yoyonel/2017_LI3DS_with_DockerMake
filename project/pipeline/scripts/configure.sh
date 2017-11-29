#!/bin/bash

set -e

configure_overlay_ws.sh

rosdep.sh

configure_catkin_ws.sh