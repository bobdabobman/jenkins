All commands are to be run from the terraform directory.

Run the terraform first

 - terraform plan
 - terraform apply

Then run the following command before running ansible

 - terraform output ansible_inventory > ../ansible/hosts.ini

Finally run:
 - ansible-playbook -i ../ansible/hosts.ini ../ansible/install_jenkins.yml --private-key ~/.ssh/my-ec2-keypair -u ubuntu

Optionally run:
 - terraform destroy
