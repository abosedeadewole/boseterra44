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
  sensitive = true
  validation {
    condition     = can(regex("^t2.", var.instance_type))
    error_message = "The Instance Type must be of t3-instance."
  }
  # default     = "t2.micro"
}

resource "aws_instance" "milua_server" {
  ami           = "ami-0629230e074c580f2"
  instance_type = var.instance_type #  if you want to insert the type "t2.micro"

  tags = {
    #    Name = "milua_server"
    Name        = "My-sever-${local.engineer_name}" # use of interpolation
    environment = local.environment

  }
}


locals {
  engineer_name = "ayomide"
  environment   = "testing environment"
}


output "public_ip_address" {
  value = aws_instance.milua_server.public_ip
  # sensitive = true

}

output "private_ip_address" {
  value = aws_instance.milua_server.private_ip
}
