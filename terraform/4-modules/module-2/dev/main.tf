

terraform {
 /* backend "remote" {
    organization = "Landmark25"

    workspaces {
      name = "trial_1"
    }
  }*/

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



module "ec2_module" {
  source = "../trial_modules/ec2"

}

module "vpc_module" {
  source     = "../trial_modules/vpc"
  tag_name   = "Ayo_module"
  cidr_block = "10.1.0.0/16"
}

