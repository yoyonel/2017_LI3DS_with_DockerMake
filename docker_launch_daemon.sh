#!/usr/bin/sh

sudo service docker stop

sudo docker daemon \
    --dns 172.21.2.14 --dns 172.16.2.91 \
    --insecure-registry=172.20.250.99:5000
