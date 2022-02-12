
terraform {
  backend "s3" {
    bucket = "terramybucket"
    key    = "dev/tfstate/terraform.tfstate"
    dynamoDB = "terra_dynamodb_lock"
    region = "us-east-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.64.0"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-2"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}


resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "terra_dynamodb_lock"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 3
  write_capacity = 3
  hash_key       = "LockID"


  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-dynamodb-table-1"
    Environment = "development"
  }
}





resource "aws_instance" "example" {
  for_each = {
    prod = "t2.medium"
    dev  = "t2.micro"
  }
  ami                    = data.aws_ami.ubuntu.id # ami-0f19d220602031aed # change ami to amazon ami
  instance_type          = each.value
  vpc_security_group_ids = [aws_security_group.allow_traffic.id] # using resource attribute reference syntax <provider>_type.<name>.<attribute>

  user_data = <<-EOF
                                                                                                             #!/bin/bash
                                                                                                                             echo "Hello, World" > index.html
                                                                                                                                             nohup busybox httpd -f -p 8080 &
                                                                                                                                                             EOF
  tags = {
    Name = "my_ec2_instance ${each.key}"
  }

}

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

resource "aws_vpc" "landmark1" {
  cidr_block = var.cidr_block

  tags = {
    "Name" = var.tag_name
  }
}


variable "cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

variable "tag_name" {
  type    = string
  default = "Ayomide_module"

}


