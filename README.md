# dolphinstor
This repo shall hold dolphinstor binary bits for demo purposes.
a) Fill up terraform.tfvars with your DO credentials.
1. Create a DO token from DO admin page.
2. Create a ssh key for your account locally, and register with DO.
3. Running "ssh-keygen -lf id_rsa.pub" will provide the ssh_fingerprint.
4. Update the above information in terraform.tfvars file..

b) Install terraform on your machine

c) Then run "terraform apply". Voila! cluster is ready!!

d) "terraform destroy" to remove all the VMs created.

e) "terraform show" display all the VMs created with their attributes.
