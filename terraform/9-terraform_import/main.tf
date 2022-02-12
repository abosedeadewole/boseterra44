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
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "North_Virgina"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "s3_server" {
  count = 2
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro" #  if you want to insert the type "t2.micro"

  tags = {
    Name        = "s3-sever-${count.index}" # use of interpolation
    owner   = local.engineer_name
    # Name        = "s3-sever-${local.engineer_name}" # use of interpolation
    environment = local.environment

  }
}


locals {
  engineer_name = "ayomide"
  environment   = "testing environment"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "milua25-kops.local"

}


output "public_ip_address" {
  value = aws_instance.s3_server[*].public_ip
}

output "private_ip_address" {
  value = aws_instance.s3_server[*].private_ip
}
