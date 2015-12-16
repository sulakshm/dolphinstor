resource "digitalocean_droplet" "demo-admin" {
    image = "14872180"
    name = "demo-admin"
    region = "sfo1"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl enable salt-master",
      "systemctl stop salt-master",
      "rm -rf /etc/salt/pki /var/cache/salt",
      "/opt/scripts/fixadmin.sh ${digitalocean_droplet.demo-admin.ipv4_address} ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "rm -f /home/cephadm/.ssh/* /home/demo/.ssh/*",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' cephadm",
      "cp /home/cephadm/.ssh/id_rsa.pub /srv/salt/users/cephadm/keys/key.pub",
      "cp /home/cephadm/.ssh/id_rsa.pub /home/cephadm/.ssh/authorized_keys",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' demo",
      "cp /home/demo/.ssh/id_rsa.pub /srv/salt/users/demo/keys/key.pub",
      "systemctl start salt-master",
      "salt-key -Dy",
    ]
  }
}
