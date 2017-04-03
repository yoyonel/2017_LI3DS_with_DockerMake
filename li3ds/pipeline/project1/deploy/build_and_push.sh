#!/usr/bin/sh
docker build \
    -t 172.20.250.99:5000/li3ds/deploy:8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c \
    --rm --force-rm \
    .

docker tag \
	172.20.250.99:5000/li3ds/deploy:8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c	\
	172.20.250.99:5000/li3ds/deploy:latest

docker push \
	172.20.250.99:5000/li3ds/deploy:8f16d2bcdf0bdbb6cfec375e34b630176c54df0ac71ea517adb3782be932727c

docker push \
	172.20.250.99:5000/li3ds/deploy:latest
