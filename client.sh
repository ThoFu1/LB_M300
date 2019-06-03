#!/bin/sh
sudo apt-get update

sudo ufw --force enable
sudo ufw allow ssh

sudo useradd -m test01
sudo addgroup --gid 2000 standard_group
sudo usermod -aG standard_group test01
