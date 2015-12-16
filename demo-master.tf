resource "digitalocean_droplet" "demo-master" {
    image = "14872177"
    name = "demo-master-${count.index}"
    region = "sfo1"
    size = "512mb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
    count=1
  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "systemctl enable salt-minion",
      "systemctl stop salt-minion",
      "/opt/scripts/fixsaltminion.sh ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "rm -rf /etc/salt/pki /var/cache/salt",
      "${self.name} > /etc/salt/minion_id",
      "systemctl restart salt-minion",
    ]
  }
}
