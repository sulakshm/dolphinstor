{% for user, args in pillar['users'].iteritems() %}
{{ user }}:
  group.present:
    - gid: {{ args['gid'] }}
  user.present:
    - home: {{ args['home'] }}
    - shell: {{ args['shell'] }}
    - uid: {{ args['uid'] }}
    - gid: {{ args['gid'] }}
{% if 'password' in args %}
    - password: {{ args['password'] }}
{% if 'enforce_password' in args %}
    - enforce_password: {{ args['enforce_password'] }}
{% endif %}
{% endif %}
    - fullname: {{ args['fullname'] }}
{% if 'groups' in args %}
    - groups: {{ args['groups'] }}
{% endif %}
    - require:
      - group: {{ user }}

{% if 'key.pub' in args and args['key.pub'] == True %}
{{ user }}_key.pub:
  ssh_auth:
    - present
    - user: {{ user }}
    - source: salt://users/{{ user }}/keys/key.pub
  ssh_known_hosts:
    - present
    - user: {{ user }}
    - key: salt://users/{{ user }}/keys/key.pub
    - name: "demo-admin"
{% endif %}
{% endfor %}

/etc/sudoers:
  file.managed:
    - source: salt://files/sudoers
    - user: root
    - group: root
    - mode: 440

/opt/nodes:
  file.directory:
    - user: root
    - group: root
    - mode: 644
    
/opt/scripts:
  file.directory:
    - user: root
    - group: root
    - mode: 777