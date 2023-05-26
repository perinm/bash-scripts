#!/bin/bash
sudo mkfs -t xfs /dev/nvme1n1
sudo mkdir -p /data
sudo mount /dev/nvme1n1 /data
sudo mkdir -p /data/docker
sudo systemctl disable --now docker
sudo usermod -aG docker $USER
sudo chown -R $USER:$USER /data