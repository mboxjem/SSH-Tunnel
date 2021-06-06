#!/bin/bash

curl -s https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/badvpn/badvpn-1.999.128.tar.bz2 | tar -C /tmp/ -xj
mkdir /tmp/badvpn-1.999.128/build
cmake /tmp/badvpn-1.999.128 -DBUILD_NOTHING_BY_DEFAULT=1 -DBUILD_TUN2SOCKS=1 -DBUILD_UDPGW=1
make install

curl -L https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/badvpn/badvpn.service --output /etc/systemd/system/badvpn.service