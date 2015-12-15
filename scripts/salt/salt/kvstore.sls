kvstore:
    pkg.installed:
    - pkgs:
      - etcd

/etc/etcd/etcd.conf:
  file.managed:
    - source: salt://files/etcd.conf.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - backup: minion

systemctl enable etcd:
  cmd.run

systemctl restart etcd:
  cmd.run

bash /opt/scripts/bootstrap.sh:
  cmd.run
