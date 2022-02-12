
locals {

  ingress = [{
    description = "Allow TLS traffic"
    port        = 443
    protocol    = "tcp"

    },
    {
      description = "Allow HTTP traffic"
      port        = 8080
      protocol    = "tcp"

    },
    {
      description = "Allow SSH traffic"
      port        = 22
      protocol    = "tcp"

    },
    {
      description = "Allow WEB traffic"
      port        = 80
      protocol    = "tcp"


  }]

  egress = [{
    description = "Allow TLS traffic"
    port        = 443
    protocol    = "tcp"

    },
    {
      description = "Allow SSH traffic"
      port        = 22
      protocol    = "tcp"

    },
    {
      description = "Allow HTTP traffic"
      port        = 8080
      protocol    = "tcp"

    },
    {
      description = "Allow WEB traffic"
      port        = 80
      protocol    = "tcp"

    }
  ]
}

data "aws_vpc" "main" {

  filter {
    name   = "tag:Name"
    values = ["main"]
  }

}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    for_each = local.ingress
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks =  ["0.0.0.0/0"] #[data.aws_vpc.main.cidr_block]
    }
  }

  dynamic "egress" {
    for_each = local.egress
    content {
      description      = egress.value.description
      from_port        = egress.value.port
      to_port          = egress.value.port
      protocol         = egress.value.protocol
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Name = "Module_tls"
  }
}

output "sg_name" {
  value = aws_security_group.allow_tls.name
}