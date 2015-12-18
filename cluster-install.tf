resource "null_resource" "cluster-install" {
    depends_on = [
        "digitalocean_droplet.admin",
        "digitalocean_droplet.minion",
    ]

  connection {
      host = "${digitalocean_droplet.admin.ipv4_address}"
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
        "/opt/scripts/fixadmin.sh ${digitalocean_droplet.admin.ipv4_address} ${digitalocean_droplet.admin.ipv4_address_private} ${digitalocean_droplet.admin.name}",
        "/opt/scripts/fixslaves.sh ${join(\" \", digitalocean_droplet.minion.*.ipv4_address_private)}",
        "salt-key -Ay",
        "salt -t 10 '*' test.ping",
        "salt-key -Ay",
        "salt -t 10 '*' test.ping",
        "salt-key -Ay",
        "salt -t 10 '*' test.ping",
        "salt-key -Ay",
        "salt -t 10 '*' test.ping",
        "salt-key -Ay",
        "salt -t 10 '*' test.ping",
        "salt -t 10 '*' test.ping",
        "salt -t 10 '*' test.ping",
        "salt-key -Ay",
        "salt -t 20 '*' state.apply common",
        "salt-cp '*' /opt/nodes/* /opt/nodes",
        "su -c /opt/scripts/ceph-install.sh cephadm",
        "salt 'demo-master-*' state.highstate",
        "salt 'demo-minion-*' state.highstate",
    ]
  }

  provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.admin.*.ipv4_address)} > node.admin"
  }
}
