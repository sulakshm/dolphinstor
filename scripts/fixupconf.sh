sed -i 's#ETCD_ADVERTISE_CLIENT_URLS=.*#ETCD_ADVERTISE_CLIENT_URLS="http://${2}:4001"#' /etc/etcd/etcd.conf
sed -i 's#ETCD_LISTEN_CLIENT_URLS=.*#ETCD_LISTEN_CLIENT_URLS="http://${2}:4001"#' /etc/etcd/etcd.conf

sed -i 's/ms_bind_ipv6\(.*\)/#ms_bind_ipv6\1/' /opt/ceph-cluster/ceph.conf
sed -i "s/mon_host = \(.*\)/mon_host = ${1}/" /opt/ceph-cluster/ceph.conf

cat >> /opt/ceph-cluster/ceph.conf << EOF
osd pool default size = 2
public_addr=${1}
EOF

sed -i 's/Defaults.*requiretty/Defaults:ceph !requiretty/' /etc/sudoers
