/etc/sudoers:
  file.managed:
    - source: salt://files/sudoers
    - user: root
    - group: root
    - mode: 440
