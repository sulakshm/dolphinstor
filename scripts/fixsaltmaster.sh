#!/bin/bash

sudo systemctl stop salt-master
sudo sed -i "s/#interface:.*/interface: ${1}/" /etc/salt/master
sudo systemctl start salt-master
