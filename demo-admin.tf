resource "digitalocean_droplet" "demo-admin" {
    image = "centos-7-0-x64"
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
        "mkdir -p /opt/scripts /srv/salt /srv/pillar /srv/salt/users/cephadm/keys /srv/salt/users/demo/keys",
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
      "sudo yum install -y etcd cryptsetup.x86_64 cryptsetup-libs.x86_64 wget salt-master",
      "chmod +x /opt/scripts/*.sh",

      "sudo cp -af /opt/scripts/salt/* /srv",
      "sudo systemctl enable salt-master",
      "/opt/scripts/fixsaltmaster.sh ${digitalocean_droplet.demo-admin.ipv4_address_private}",
      "sudo systemctl start salt-master",
      "sudo useradd -m cephadm",
      "echo \"cephadm:c3ph@dm1n\" | chpasswd",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" ' cephadm",
      "sudo cp /home/cephadm/.ssh/id_rsa.pub /srv/salt/users/cephadm/keys/key.pub",
      "sudo useradd -m demo",
      "echo \"demo:demo\" | chpasswd",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" ' demo",
      "sudo cp /home/demo/.ssh/id_rsa.pub /srv/salt/users/demo/keys/key.pub",
      "sudo yum install -y ceph-deploy",
      "sudo yum install -y ntp ntpdate ntp-doc",
    ]
  }
}

#resource "null_resource" "demo-admin" {
#    depends_on = [
#		"digitalocean_droplet.demo-admin",
#		"digitalocean_droplet.demo-minion-1",
#    ]
#
#    connection {
#      host = "${digitalocean_droplet.demo-admin.ipv4_address_private}"
#      user = "root"
#      type = "ssh"
#      key_file = "${var.pvt_key}"
#      timeout = "2m"
#    }
#
#    provisioner "file" { 
#     source = "${path.module}/scripts/fixuphostfiles.sh"
#     destination = "/opt/ceph-cluster/fixuphostfiles.sh"
#    }
#
#    provisioner "remote-exec" {
#        inline = [
#           "chmod +x /opt/ceph-cluster/fixuphostfiles.sh",
#           "/opt/ceph-cluster/fixuphostfiles.sh demo-minion-1 ${digitalocean_droplet.demo-minion-1.ipv4_address_private}",
#           "su -c ssh-copy-id ${digitalocean_droplet.demo-minion-1.ipv4_address_private} infernalis",
#        ]
#    }
#}
