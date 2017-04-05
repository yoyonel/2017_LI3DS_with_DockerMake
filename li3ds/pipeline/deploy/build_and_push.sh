#!/usr/bin/env bash

#SHA_PROJECT=8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c
SHA_PROJECT=$(cat $1/sha256.txt)

DOCKER_IP_REGISTRY=172.20.250.99:5000

echo "[COPY] Catkin workspace ..."
cp -r $PATH_TO_CATKIN_WS_VOLUME .
echo "[COPY] Overlay workspace ..."
cp -r $PATH_TO_OVERLAY_WS_VOLUME .

echo "[DOCKER] build image for deployement ..."
echo -e "FROM li3ds-prototype:$SHA_PROJECT\n$(cat Dockerfile.template)" > Dockerfile
docker build \
    -t $DOCKER_IP_REGISTRY/li3ds/deploy:$SHA_PROJECT \
    --rm --force-rm \
    --build-arg HTTP_PROXY=$HTTP_PROXY \
    --build-arg HTTPS_PROXY=$HTTPS_PROXY \
    --build-arg https_proxy=$https_proxy \
    --build-arg http_proxy=$http_proxy \
    --build-arg ftp_proxy=$ftp_proxy \
    --build-arg FTP_PROXY=$FTP_PROXY \
    .
# Remove tempory files
rm Dockerfile
rm -r catkin
rm -r overlay

echo "[DOCKER] Tag images"
docker tag \
	$DOCKER_IP_REGISTRY/li3ds/deploy:$SHA_PROJECT	\
	$DOCKER_IP_REGISTRY/li3ds/deploy:latest

echo "[DOCKER] Push to registry"
docker push \
	$DOCKER_IP_REGISTRY/li3ds/deploy:$SHA_PROJECT

docker push \
	$DOCKER_IP_REGISTRY/li3ds/deploy:latest
