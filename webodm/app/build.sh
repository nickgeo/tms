#!/bin/bash
sudo -i

# install packages
apt-get -y update && apt-get -y upgrade
apt-get install -y docker.io docker-compose
apt-get install -y python-pip python3-pip python3-venv

# create new user
adduser odm
usermod -aG  odm
usermod -aG docker odm

# make service to run at startup
cat <<'EOF' >> /etc/systemd/system/webodm.service
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
chown odm:odm /etc/systemd/system/webodm.service

# make app folder
mkdir /webodm/
cd /webodm/

# download app code
git clone https://github.com/OpenDroneMap/WebODM --config core.autocrlf=input --depth 1

# change owner of app folder recursively
chown -R odm:odm /webodm/

# enable and start service
systemctl enable webodm
systemctl status webodm