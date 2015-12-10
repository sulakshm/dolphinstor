resource "null_resource" "cluster-config" {
    depends_on = [
        "digitalocean_droplet.demo-admin",
        "digitalocean_droplet.demo-master",
        "digitalocean_droplet.demo-minion",
    ]

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
