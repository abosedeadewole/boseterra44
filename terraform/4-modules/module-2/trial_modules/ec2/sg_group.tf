

variable "ingressRules" {
  description = "The rules for incoming traffic"
  type        = list(number)
  default     = [80, 53, 8080, 443]
}

variable "egressRules" {
  description = "The rules for Outgoing traffic"
  type        = list(number)
  default     = [8080, 9000, 32120]
}

data "aws_vpc" "main" {
  default = true
}


resource "aws_security_group" "allow_traffic" {
  name        = "allow_traffic"
  description = "Allow Outbound and Inbound traffic"
  vpc_id      = data.aws_vpc.main.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingressRules
    content {
      description      = "port.description" # not sure
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.main.cidr_block]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  }


  dynamic "egress" {
    iterator = port
    for_each = var.egressRules
    content {
      description      = "description" # not sure
      from_port        = port.value
      to_port          = port.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids  = []
      security_groups  = []
      self             = false

    }
  }

  tags = {
    Name = "allow_tls"
  }
}

