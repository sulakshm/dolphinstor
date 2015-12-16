resource "digitalocean_droplet" "demo-admin" {
    image = "dsimg-demo-admin-v1"
    name = "demo-admin"
    region = "sfo1"
    size = "1gb"
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

  provisioner "file" {
     source = "${path.module}/scripts/"
     destination = "/opt/scripts/"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /opt/scripts/*.sh",
      "/opt/scripts/fixadmin.sh ${digitalocean_droplet.demo-admin.ipv4_address} ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' cephadm",
      "cp /home/cephadm/.ssh/id_rsa.pub /srv/salt/users/cephadm/keys/key.pub",
      "cp /home/cephadm/.ssh/id_rsa.pub /home/cephadm/.ssh/authorized_keys",
      "useradd -m demo",
      "echo \"demo:demo\" | chpasswd",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' demo",
      "cp /home/demo/.ssh/id_rsa.pub /srv/salt/users/demo/keys/key.pub",
      "systemctl enable salt-master",
      "systemctl start salt-master",
    ]
  }
}

