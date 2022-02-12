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


variable "instance_type" {
  description = "Size of the EC2 instance"
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "The Instance Type must be of t3-instance."
  }
  # default     = "t2.micro"
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

resource "aws_s3_bucket" "class25-test" {
  bucket = "class25-test-depends-on"
  acl    = "private"
  depends_on = [

    aws_instance.s3_server
  ]

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_instance" "s3_server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type #  if you want to insert the type "t2.micro"

  tags = {
    Name        = "s3-sever-${local.engineer_name}" # use of interpolation
    environment = local.environment

  }
}


locals {
  engineer_name = "ayomide"
  environment   = "testing environment"
}


output "public_ip_address" {
  value = aws_instance.s3_server.public_ip
  # sensitive = true

}

output "private_ip_address" {
  value = aws_instance.s3_server.private_ip
}
