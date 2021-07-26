#!/bin/bash

echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
wget -q -O- http://www.webmin.com/jcameron-key.asc | apt-key add
apt update; apt upgrade -y
apt install webmin -y