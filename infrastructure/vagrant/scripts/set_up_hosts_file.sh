#!/usr/bin/env bash

sed -i "/$(hostname)/d" /etc/hosts
echo "" >> /etc/hosts
for node in "$@"
do
  host=(${node//=/ })
  grep "${host[0]}" /etc/hosts || echo "${host[1]} ${host[0]}" >> /etc/hosts
done
echo "" >> /etc/hosts
