terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
profile = var.profile
region = var.aws-region
}


module "ec2-instance" {
  source = "./ec2-instance"
}

module "s3-bucket" {
  source = "./s3-bucket"
  bucket-name = "assessment-02-2022"
  s3-iam-role = module.ec2-instance.iam-role-arn
}