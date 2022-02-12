terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.64.2"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-2"
  # Configuration options
}

locals {
  ingress = [{
    description : "port 443"
    port     = 443
    protocol = "tcp"
    },
    {
      description : "port 80"
      port     = 80
      protocol = "tcp"
  }]
}

data "aws_vpc" "main" {
  id = "vpc-097a1c62"
}

resource "aws_security_group" "local_test25" {
  name        = "test25"
  description = "Allow Http and TLS inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description      = ingress.value.description
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = ingress.value.protocol
      cidr_blocks      = [data.aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }

  egress = [
    { description      = "Ougoing Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  tags = {
    Name = "allow_tls"
  }
}
