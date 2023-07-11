resource "aws_vpc" "vpc_ansible" {
  cidr_block = var.vpc_cidr
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc_ansible.id
  cidr_block              = var.public_cidrblock
  availability_zone       = var.av_zone
  map_public_ip_on_launch = true

  tags = {
    "Name" = "public"
  }

}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc_ansible.id
  cidr_block        = var.private_cidrblock
  availability_zone = var.av_zone

  tags = {
    "Name" = "private"
  }

}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc_ansible.id

  tags = var.tags

}

resource "aws_eip" "eip" {
  vpc = true
  tags = {
    "Name" = "eip for ansible"
  }

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet.id

  depends_on = [aws_internet_gateway.gw]

  tags = {
    "Name" = "nat for ansible"
  }

}

# public route
resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.vpc_ansible.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    "Name" = "public route"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route.id

}

# private route
resource "aws_route_table" "private_route" {
  vpc_id = aws_vpc.vpc_ansible.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    "Name" = "private route"
  }

}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route.id

}



resource "aws_network_acl" "network_acl" {
  vpc_id = aws_vpc.vpc_ansible.id
  subnet_ids = [ aws_subnet.private_subnet.id ]

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    action = "allow"
    rule_no = 200
    cidr_block  = "0.0.0.0/0"
  }

#   ingress {
#     from_port   = 0
#     to_port     = 65535
#     protocol    = "-1"
#     action = "deny"
#     rule_no = 100
#     cidr_block  = "0.0.0.0/0"
#   }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    action = "allow"
    rule_no = 200
    cidr_block  = "0.0.0.0/0"
  }
}