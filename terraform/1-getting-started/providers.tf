

terraform {
   backend "remote" {
    organization = "Landmark25"

    workspaces {
      name = "terraform-getting-started"
    }
   }
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
  alias = "North_Virgina"
}
