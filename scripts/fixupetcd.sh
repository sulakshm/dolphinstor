sed -i "s#ETCD_ADVERTISE_CLIENT_URLS=.*#ETCD_ADVERTISE_CLIENT_URLS=\"http://${1}:4001\"#" /etc/etcd/etcd.conf
sed -i "s#ETCD_LISTEN_CLIENT_URLS=.*#ETCD_LISTEN_CLIENT_URLS=\"http://${1}:4001\"#" /etc/etcd/etcd.conf
