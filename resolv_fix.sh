#!/bin/bash
RESOLV=/run/resolvconf/resolv.conf

sudo chmod 666 $RESOLV
echo "nameserver 192.168.0.1
search home.local" > $RESOLV
sudo chmod 644 $RESOLV
