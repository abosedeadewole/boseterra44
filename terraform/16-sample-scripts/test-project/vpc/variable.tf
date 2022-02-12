variable "aws_region" {
  description = "value"
  type = string
  default = "us-west-2"
}

variable "availability_zone_public" {
  description = "value"
  type = string
  default = "us-west-2a"
}
variable "availability_zone_private" {
  description = "value"
  type = string
  default = "us-west-2b"
}

variable "vpc_cidr" {
  description = "metadata_VPC"
  default     = "10.0.0.0/16"
}

variable "Public_subnets_cidr" {
  default = "10.0.101.0/24"
}

variable "Private_subnets_cidr" {
  default = "10.0.1.0/24"
}
