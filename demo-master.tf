resource "digitalocean_droplet" "demo-master" {
    image = "centos-7-0-x64"
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
      "sudo mkdir -p /opt/scripts",
    ]
  }

  provisioner "file" {
     source = "${path.module}/scripts/"
     destination = "/opt/scripts/"
  }

  provisioner "file" {
     source = "${path.module}/scripts/cephdeploy.repo"
     destination = "/etc/yum.repos.d/cephdeploy.repo"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo yum install -y epel-release yum-utils",
      "sudo yum-config-manager --enable cr",
      "sudo yum install -y etcd cryptsetup.x86_64 cryptsetup-libs.x86_64",
      "sudo chmod +x /opt/scripts/*.sh",
      "/opt/scripts/fixupetcd.sh ${digitalocean_droplet.demo-master-0.ipv4_address_private}",
      "sudo systemctl enable etcd",
      "sudo systemctl start etcd",
    ]
  }
}
