resource "digitalocean_droplet" "demo-minion-1" {
    image = "centos-7-0-x64"
    name = "demo-minion-1"
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
      timeout = "2m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /opt/scripts",
    ]
  }

  provisioner "file" {
     source = "${path.module}/scripts/"
     destination = "/opt/scripts/"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo yum install -y etcd cryptsetup.x86_64 cryptsetup-libs.x86_64",
      "sudo chmod +x /opt/scripts/*.sh",
      "/opt/scripts/fixupetcd.sh ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "sudo systemctl enable etcd",
      "sudo systemctl start etcd",
    ]
  }
}
