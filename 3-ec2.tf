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



# bastion host

resource "aws_instance" "bation_host" {
  #   ami                         = "ami-016eb5d644c333ccb"
  # swith to ubuntu to test k3s
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.master_node_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.kubernetes.name

  key_name = "ansible_ec2"

  tags = {
    "Name" = "bastion"
  }

}


# add another ec2 as kubernetes node
resource "aws_instance" "node" {
  #   ami                         = "ami-016eb5d644c333ccb"
  # swith to ubuntu to test k3s
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  security_groups             = [aws_security_group.worker_node_sg.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.kubernetes.name

  key_name = "ansible_ec2"

  tags = {
    "Name" = "node"
  }

}