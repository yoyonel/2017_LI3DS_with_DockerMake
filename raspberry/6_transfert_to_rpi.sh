#!/usr/bin/env bash

source env.sh
source scripts/bash_tools.sh

echo_i "Transfert to raspberry LI3DS project:"
echo_i "- Raspberry IP: $STEP6_RPI_IP"
echo_i "- Path to deploy archives: $STEP6_RPI_DEPLOY_PATH/."
# catkin
scp catkin_ws.tar.gz \
    $STEP6_RPI_IP:$STEP6_RPI_DEPLOY_PATH/.
# overlay
scp overlay_ws.tar.gz \
    $STEP6_RPI_IP:$STEP6_RPI_DEPLOY_PATH/.

