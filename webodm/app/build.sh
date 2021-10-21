#!/bin/bash

# install packages
sudo apt-get -y update && apt-get -y upgrade
sudo apt-get install -y docker.io docker-compose
sudo apt-get install -y python-pip python3-pip python3-venv

# create new user
sudo adduser odm
sudo usermod -aG sudo odm
sudo usermod -aG docker odm

# make service to run at startup
sudo cat <<'EOF' >> /etc/systemd/system/webodm.service
[Unit]
Description=WebODM
After=network.target
After=systemd-user-sessions.service
After=network-online.target

[Service]
Type=simple
ExecStart=/webodm/WebODM/webodm.sh start
ExecStop=/webodm/WebODM/webodm.sh stop
TimeoutSec=30
Restart=on-failure
RestartSec=30
StartLimitInterval=350
StartLimitBurst=10

[Install]
WantedBy=multi-user.target
EOF

# change owner of service
sudo chown odm:odm /etc/systemd/system/webodm.service

# make app folder
sudo mkdir /webodm/
sudo cd /webodm/

# download app code
sudo git clone https://github.com/OpenDroneMap/WebODM --config core.autocrlf=input --depth 1

# change owner of app folder recursively
sudo chown -R odm:odm /webodm/

# enable and start service
sudo systemctl enable webodm
sudo systemctl status webodm