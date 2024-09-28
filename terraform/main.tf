output "ansible_inventory" {
  value = <<EOF
[jenkins]
${aws_instance.jenkins_server.public_ip}
EOF
}