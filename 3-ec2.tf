resource "aws_key_pair" "ansible_ec2" {
  key_name   = "ansible_ec2"
  public_key = file("~/.ssh/ansible.pub")

}

resource "aws_instance" "ansible_1" {
  ami           = "ami-016eb5d644c333ccb"
  instance_type = var.ec2_type
  subnet_id     = aws_subnet.private_subnet.id

  key_name        = "ansible_ec2"
  security_groups = [aws_security_group.private_instance_sg.id]

  depends_on = [aws_security_group.private_instance_sg]
  tags = {
    "Name" = "VM-1"
  }

  user_data = <<-EOT
    #!/bin/bash
    echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config
    echo "GatewayPorts yes" >> /etc/ssh/sshd_config
    systemctl restart sshd
    EOT


}


# # ebs volume
# resource "aws_ebs_volume" "VM-1_volume" {
#     availability_zone = var.av_zone
#     size = 2

#     tags = {
#       "Name" = "VM-1_volume"
#     }

# }

# resource "aws_volume_attachment" "ebs_att" {
#     device_name = "/dev/ebs"
#     volume_id = aws_ebs_volume.VM-1_volume.id
#     instance_id = aws_instance.ansible_1.id

# }


# bastion host

resource "aws_instance" "bation_host" {
  ami                         = "ami-016eb5d644c333ccb"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.ansible_sg_ssh.id]
  associate_public_ip_address = true

  key_name = "ansible_ec2"

  tags = {
    "Name" = "bastion"
  }

}