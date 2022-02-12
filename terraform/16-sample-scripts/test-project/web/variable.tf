variable "availability_zone" {
   description = "value"
   type = string
}

variable "Instance_Name" {
    description = "value"
    type = string
    default = "web_server"
}

variable "Instance_Type" {
    description = "value"
    type = string
    default = "t2.micro"
}

variable "security_group" {
  description = "value"
}

variable "subnet_id" {
  description = "value"
}
variable "subnet_id_public" {
  description = "value"
}

variable "security_group_ids" {
  description = "value"
}


variable "aws_region" {
  description = "value"
}

variable "vpc_id" {
  description = "value"
}

variable "instance_profile" {
  description = "value"
}

variable "route_table" {
  description = "value"
}
