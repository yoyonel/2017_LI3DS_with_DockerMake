#!/usr/bin/env bash

# read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
LOWERPORT=32768
UPPERPORT=61000
while : ; do
  PULSE_PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
  ss -lpn | grep -q ":$PULSE_PORT " || break
done
