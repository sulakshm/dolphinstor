resource "digitalocean_droplet" "demo-minion" {
    image = "14882595"
    name = "demo-minion-${count.index}"
    region = "sfo1"
    size = "1gb"
    private_networking = true
    ssh_keys = [
      "${var.ssh_fingerprint}"
    ]
    count=3
  connection {
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
      "/opt/scripts/fixsaltminion.sh ${digitalocean_droplet.demo-admin.ipv4_address_private} ${self.name}",
    ]
  }
}
