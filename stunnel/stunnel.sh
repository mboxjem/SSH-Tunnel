#!/bin/bash

curl -L https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/stunnel/stunnel.pem --output /etc/stunnel/stunnel.pem
curl -L https://raw.githubusercontent.com/mboxjem/SSH-Tunnel/main/stunnel/stunnel.conf --output /etc/stunnel/stunnel.conf

chmod +x /etc/stunnel/stunnel.pem