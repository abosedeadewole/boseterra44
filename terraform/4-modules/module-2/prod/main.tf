
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
      version = "3.64.2"
    }
  }
}
provider "aws" {
  profile = "default"
  region  = "us-east-2"
  alias = "Ohio"
  
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
  alias   = "North_Virgina"
}



module "ec2_module" {
  source = "../trial_modules/ec2"
  providers = {
    aws = aws.North_Virgina
  }
}

module "vpc_module" {
  source     = "../trial_modules/vpc"
  tag_name   = "Ayo_module"
  cidr_block = "10.1.0.0/16"
  providers = {
    aws = aws.North_Virgina
  }
}
