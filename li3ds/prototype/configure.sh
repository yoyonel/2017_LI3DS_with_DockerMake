#!/bin/bash

set -e

sh configure_overlay_ws.sh

sh rosdep.sh

sh configure_catkin_ws.sh