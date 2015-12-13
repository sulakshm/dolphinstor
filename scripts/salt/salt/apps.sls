dolphinstorpkgs:
    pkg.installed:
    - pkgs:
      - docker

/etc/sysconfig/docker:
  file.managed:
    - source: salt://files/docker
    - template: jinja
    - user: root
    - group: root
    - mode: 644
