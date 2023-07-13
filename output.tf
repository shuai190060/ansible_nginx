

output "bastion_ip" {
  value = aws_instance.bation_host.public_ip
}

output "vm1_ip" {
  value = aws_instance.ansible_1.private_ip
}

output "node_ip" {
  value = aws_instance.node.public_ip
}