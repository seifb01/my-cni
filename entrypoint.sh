#!/usr/bin/env sh

cp /cni/10-my-cni.conf /etc/cni/net.d/
cp /cni/my-cni /opt/cni/bin/
sleep infinity
