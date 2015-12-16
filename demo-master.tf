resource "digitalocean_droplet" "demo-master" {
    image = "dsimg-demo-master-v1"
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

  provisioner "file" {
     source = "${path.module}/scripts/"
     destination = "/opt/scripts/"
  }

  provisioner "remote-exec" {
    inline = [
      "/opt/scripts/fixsaltminion.sh ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "systemctl enable salt-minion",
      "systemctl start salt-minion",
    ]
  }
}
