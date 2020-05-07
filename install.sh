#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run me as root."
  exit
fi

cp vow.sh /usr/local/bin/vow
cp vow.service /etc/systemd/system/vow.service
cp vow.conf /etc/vow.conf

systemctl daemon-reload
systemctl enable vow
systemctl start vow

echo "Vow is now installed and ready to protect you whenever you're on an unsafe wifi."
echo
echo "Use 'systemctl stop vow' to disable it whenever you want to."
