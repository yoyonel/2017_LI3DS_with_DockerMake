#!/usr/bin/env bash

sudo service docker stop

sudo -E dockerd \
    --dns 172.21.2.14 --dns 172.16.2.91 \
    --insecure-registry=172.20.250.99:5000
