#!/bin/bash

cd pi-gen
touch ./stage3/SKIP ./stage4/SKIP ./stage5/SKIP
touch ./stage4/SKIP_IMAGES ./stage5/SKIP_IMAGES
mkdir -p ./stage2/04-namib/files
mkdir -p ./stage2/04-namib/flows
cp ../to_display.py stage2/04-namib/files/
cp ../flows_WeatherStation.json stage2/04-namib/flows
cp ../settings.js stage2/04-namib/flows
cp ../changeCredentials.sh stage2/04-namib/files/

cat > ./stage2/04-namib/00-packages << EOL
nodered
python3-pip
libatlas-base-dev
python3-rpi.gpio
python3-spidev
git
ttf-mscorefonts-installer
libopenjp2-7
libtiff5
EOL

cat > ./stage2/04-namib/00-run-chroot.sh << EOL
echo "mudurl \"https://gitlab.freedesktop.org/sw0rd/MUD-Files/-/raw/master/weatherstation.mud.json\"" >> /etc/dhcpcd.conf
echo "dtparam=spi=on" >> /boot/config.txt
systemctl enable nodered.service
pip3 install Pillow st7735 numpy
cd /usr/lib/node_modules
npm install mcollina/node-coap
npm install node-red-contrib-coap
npm install node-red-dashboard
npm install node-red-node-ui-table
npm install node-red-contrib-wot-discovery
EOL

cat > ./stage2/04-namib/01-run.sh << EOL
install -m 644 files/* "\${ROOTFS_DIR}/home/pi/"
install -d "\${ROOTFS_DIR}/home/pi/.node-red/"
install -m 644 flows/* "\${ROOTFS_DIR}/home/pi/.node-red/"
EOL

cat > ./stage2/04-namib/02-run-chroot.sh << EOL
chmod 744 /home/pi/changeCredentials.sh
chown pi /home/pi/*
chown pi /home/pi/.node-red
chown pi /home/pi/.node-red/*
EOL

chmod +x ./stage2/04-namib/00-run-chroot.sh
chmod +x ./stage2/04-namib/02-run-chroot.sh
chmod +x ./stage2/04-namib/01-run.sh
./build-docker.sh -c ../namib-config
