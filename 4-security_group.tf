resource "aws_security_group" "ansible_sg_ssh" {
  vpc_id = aws_vpc.vpc_ansible.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "ssh"
  }

}

resource "aws_security_group" "private_instance_sg" {
  vpc_id = aws_vpc.vpc_ansible.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

#   egress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     cidr_blocks     = ["0.0.0.0/0"]
#     security_groups = [aws_security_group.ansible_sg_ssh.id]
#   }
     egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.ansible_sg_ssh.id]
  }

  depends_on = [aws_security_group.ansible_sg_ssh]
  tags = {
    "Name" = "ssh"
  }

}