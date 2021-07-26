#!/bin/bash

apt update; apt upgrade -y
bash <(curl -Ls https://install.speedtest.net/app/cli/install.deb.sh)
apt install speedtest -y