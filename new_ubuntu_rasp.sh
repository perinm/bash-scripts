#!/bin/bash
sudo apt-get update -y && sudo apt-get full-upgrade -y && sudo apt-get autoremove -y && sudo apt-get clean -y && sudo apt-get autoclean -y \
    && sudo snap refresh

FILE=~/.ssh/id_ed25519
if [ -f $FILE ]; then
    echo "$FILE exists."
else
    ssh-keygen -o -a 100 -t ed25519 -f $FILE -C "lucasperinm@gmail.com" -q -N ""
fi

sudo apt install -y gdebi git htop