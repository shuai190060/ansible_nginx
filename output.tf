output "public_ip" {
    value = aws_nat_gateway.nat.public_ip
}

output "bastion_ip" {
  value = aws_instance.bation_host.public_ip
}

output "vm1_ip" {
  value = aws_instance.ansible_1.private_ip
}