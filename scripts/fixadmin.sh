#!/bin/bash

sed -i '/demo-admin/d' /etc/hosts
echo "$2 demo-admin" >> /etc/hosts

mkdir -p /opt/nodes
chmod 0755 /opt/nodes
echo "$1" > /opt/nodes/admin.public
echo "$2" > /opt/nodes/admin.private

echo "Host demo-admin" >> /etc/ssh/ssh_config
echo "  StrictHostKeyChecking no" >> /etc/ssh/ssh_config

sed -i "s/#interface:.*/interface: ${2}/" /etc/salt/master
