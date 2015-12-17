resource "digitalocean_droplet" "demo-admin" {
    image = "14882602"
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
      "/opt/scripts/fixadmin.sh ${digitalocean_droplet.demo-admin.ipv4_address} ${digitalocean_droplet.demo-admin.ipv4_address_private}",
    ]
  }
}
