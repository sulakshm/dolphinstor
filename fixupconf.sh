sed -i 's/ms_bind_ipv6\(.*\)/#ms_bind_ipv6\1/' /opt/ceph-cluster/ceph.conf
sed -i "s/mon_host = \(.*\)/mon_host = ${1}/" /opt/ceph-cluster/ceph.conf

cat >> /opt/ceph-cluster/ceph.conf << EOF
osd pool default size = 2
public_addr=${1}
EOF
