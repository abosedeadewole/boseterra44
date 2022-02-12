terraform {
  backend "remote" {
    organization = "Landmark25"

    workspaces {
      name = "terraform_sample_2"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
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

resource "aws_instance" "web" {
  ami               = data.aws_ami.ubuntu.id
  instance_type     = "t2.micro"
  availability_zone = "us-east-2a"
  vpc_security_group_ids = [ aws_security_group.cloudwalker.id ]
  key_name          = aws_key_pair.terraform_key.key_name
  subnet_id = aws_subnet.secondary_cidr.id
  tags = {
    Name = "terraform_sample"
  }
}

output "instance_public_ip" {
  description = "Instance_Public_Ip"
  value = aws_instance.web.public_ip
}

output "instance_private_ip" {
  description = "Instance_private_Ip"
  value = aws_instance.web.private_ip
}