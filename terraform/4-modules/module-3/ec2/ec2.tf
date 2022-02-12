variable "ec2Name" {
  type = string
}

resource "aws_instance" "ec2" {
  ami = "ami-0dd0ccab7e2801812"
  instance_type = "t2.micro"
  tags = {
    Name = var.ec2Name
  }
}

output "instance_id" {
  value = aws_instance.ec2.id
}