#!/bin/bash
sudo systemctl stop salt-minion
sed -i "s/#master:.*/master: ${1}/" /etc/salt/minion
sudo systemctl restart salt-minion
