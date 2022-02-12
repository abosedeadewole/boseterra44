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


module "ec2module" {
  source = "./ec2"
  ec2Name = "Name from the  Module"
}

output "module_output" {
  value = module.ec2module.instance_id
}