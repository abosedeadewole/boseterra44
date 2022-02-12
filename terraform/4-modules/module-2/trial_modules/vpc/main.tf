resource "aws_vpc" "landmark1"{
cidr_block = var.cidr_block

tags = {
  "Name" = var.tag_name
}
}


variable "cidr_block" {
  type = string
}

variable "tag_name" {
    type = string
}
