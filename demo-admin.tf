resource "digitalocean_droplet" "demo-admin" {
    image = "centos-7-0-x64"
    name = "demo-admin"
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
        "mkdir -p /opt/scripts /srv/salt /srv/pillar /srv/salt/users/cephadm/keys /srv/salt/users/demo/keys /srv/salt/files",
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

  provisioner "file" {
     source = "${path.module}/scripts/salt/salt/files/sudoers"
     destination = "/etc/sudoers"
  }

  provisioner "remote-exec" {
    inline = [
      "export PATH=$PATH:/usr/bin",
      "sudo chmod 0440 /etc/sudoers",
      "sudo yum install -y epel-release yum-utils",
      "sudo yum-config-manager --enable cr",
      "sudo yum install -y yum-plugin-priorities",
 
      "sudo yum install -y etcd cryptsetup.x86_64 cryptsetup-libs.x86_64 wget salt-master",
      "chmod +x /opt/scripts/*.sh",
      "sudo cp -af /opt/scripts/salt/* /srv",
      "/opt/scripts/fixadmin.sh ${digitalocean_droplet.demo-admin.ipv4_address} ${digitalocean_droplet.demo-admin.ipv4_address_private}",

      "sudo systemctl enable salt-master",
      "sudo systemctl start salt-master",
      "sudo useradd -m -G wheel cephadm",
      "echo \"cephadm:c3ph@dm1n\" | chpasswd",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' cephadm",
      "sudo cp /home/cephadm/.ssh/id_rsa.pub /srv/salt/users/cephadm/keys/key.pub",
      "sudo cp /home/cephadm/.ssh/id_rsa.pub /home/cephadm/.ssh/authorized_keys",
      "sudo useradd -m demo",
      "echo \"demo:demo\" | chpasswd",
      "su -c 'cat /dev/zero | ssh-keygen -t rsa -N \"\" -q' demo",
      "sudo cp /home/demo/.ssh/id_rsa.pub /srv/salt/users/demo/keys/key.pub",
      "sudo yum install -y ceph-deploy",
      "sudo yum install -y ntp ntpdate ntp-doc",
    ]
  }
}

