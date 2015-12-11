resource "null_resource" "cluster-config" {
    depends_on = [
        "digitalocean_droplet.demo-admin",
        "digitalocean_droplet.demo-master",
        "digitalocean_droplet.demo-minion",
    ]

  connection {
      host = "${digitalocean_droplet.demo-admin.ipv4_address}"
      user = "root"
      type = "ssh"
      key_file = "${var.pvt_key}"
      timeout = "10m"
  }

  provisioner "remote-exec" {
    inline = [
        "salt-key -Ay",
    ]
  }

    provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.demo-admin.*.ipv4_address)} > node.admin"
    }

    provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.demo-master.*.ipv4_address_private)} > node.master.private"
    }

    provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.demo-master.*.ipv4_address)} > node.master.public"
    }

  provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.demo-minion.*.ipv4_address_private)} > node.minion.private"
  }
  provisioner "local-exec" {
     command = "echo ${join(\" \", digitalocean_droplet.demo-minion.*.ipv4_address)} > node.minion.public"
  }
}
