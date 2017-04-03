#!/usr/bin/sh

SHA_PROJECT=8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c

echo "[COPY] Catkin workspace ..."
cp -r ../../../.volumes/pipeline/$SHA_PROJECT/catkin .
echo "[COPY] Overlay workspace ..."
cp -r ../../../.volumes/pipeline/$SHA_PROJECT/overlay .

echo "[DOCKER] build image for deployement ..."
docker build \
    -t 172.20.250.99:5000/li3ds/deploy:$SHA_PROJECT \
    --rm --force-rm \
    .

echo "[DOCKER] Tag images"
docker tag \
	172.20.250.99:5000/li3ds/deploy:$SHA_PROJECT	\
	172.20.250.99:5000/li3ds/deploy:latest

echo "[DOCKER] Push to registry"
docker push \
	172.20.250.99:5000/li3ds/deploy:$SHA_PROJECT

docker push \
	172.20.250.99:5000/li3ds/deploy:latest
