#!/bin/bash
systemctl stop salt-minion
sed -i "s/#master:.*/master: ${1}/" /etc/salt/minion
sed -i "s/#acceptance_wait_time:.*/acceptance_wait_time: 5/" /etc/salt/minion
sed -i "s/#ping_interval:.*/ping_interval: 1/" /etc/salt/minion
systemctl restart salt-minion
