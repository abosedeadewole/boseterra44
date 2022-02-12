terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "Ayomide-aws"
}

module "db" {
  source = "./db"
}

module "web" {
  source = "./web"
  instance_type = "t2.micro"
  Instance_Name = "web_server"
}

output "PrivateIP" {
  value = module.db.private_ip
}

output "PublicIP" {
  value = module.web.pub_ip
}