#!/bin/sh
#launcher.sh # navigate to home directory, then to this directory, then execute python script, then back home
locale
cd /
cd /home/rasp-pando/bash-scripts/3D-PRINTER/
sudo python3 ./fan_ctrl.py &
cd /
