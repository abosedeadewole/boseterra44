variable "vpc_id" {
  description = "vpc indentity"
  type        = string
  default     = "vpc-097a1c62"
}

variable "instance_type" {
  description = "type of instance to be deployed"
  type        = string
  default     = "t2.micro"
}