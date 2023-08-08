variable "region" {
  default = "us-east-1"

}

variable "vpc_cidr" {
  default = "10.1.0.0/16"

}

variable "public_cidrblock" {
  default = "10.1.0.0/24"
}

variable "private_cidrblock" {
  default = "10.1.1.0/24"

}

variable "av_zone" {
  default = "us-east-1a"

}

variable "tags" {
  description = "Tags for the resource"
  type        = map(string)
  default = {
    "Name" = "ansible"
  }
}

variable "ec2_type" {
  default = "t2.micro"
}

variable "s3_name" {
  default = "papavonning"
}