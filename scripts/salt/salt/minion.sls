dolphinstorpkgs:
    pkg.installed:
    - pkgs:
      - docker
      - cryptsetup
      - cryptsetup-libs
      - etcd

/etc/sysconfig/docker:
  file.managed:
    - source: salt://files/docker
    - template: jinja
    - user: root
    - group: root
    - mode: 644

/usr/bin/docker:
  file.managed:
    - source: salt://binary/dolphindocker
    - backup: minion

systemctl enable docker:
  cmd.run

systemctl restart docker:
  cmd.run
