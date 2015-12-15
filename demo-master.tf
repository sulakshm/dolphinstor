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
      "mkdir -p /opt/scripts",
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
      "yum install -y epel-release yum-utils",
      "yum-config-manager --enable cr",
      "yum install -y yum-plugin-priorities",
      "yum install -y salt-minion",
      "chmod +x /opt/scripts/*.sh",
      "systemctl enable salt-minion",
      "/opt/scripts/fixsaltminion.sh ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "systemctl start salt-minion",
    ]
  }
}
