#!/usr/bin/env bash

adduser "$1"
echo "$1:$2" | chpasswd
usermod -aG wheel "$1"
mkdir "/home/$1/.ssh"
ssh-keygen -t rsa -N "" -f "/home/$1/.ssh/id_rsa" 2>/dev/null <<< y >/dev/null
chown "$1:" -R "/home/$1/.ssh"
