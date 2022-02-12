terraform {
  backend "s3" {
    bucket = "terramybucket"
    key    = "dev/tfstate/terraform.tfstate"
    region = "us-east-2"
  }

  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = var.region
  access_key = "AKIAWXK7VXC7O74IQBBG"
  secret_key = "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"
}


provider "aws" {
  region     = var.region
  alias      = "Account-2"
  access_key = "AKIATTBT4GJ52HCLC5PY"
  secret_key = "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"
}
