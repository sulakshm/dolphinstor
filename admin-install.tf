resource "digitalocean_droplet" "admin" {
    image = "14900409"
    name = "demo-master-0"
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

  provisioner "remote-exec" {
    inline = [
      "/opt/scripts/fixadmin.sh ${digitalocean_droplet.admin.ipv4_address} ${digitalocean_droplet.admin.ipv4_address_private} ${digitalocean_droplet.admin.name}",
    ]
  }
}
