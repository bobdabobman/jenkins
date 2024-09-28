output "ansible_inventory" {
  value = "[jenkins]\n${aws_instance.jenkins_server.public_ip}"
}