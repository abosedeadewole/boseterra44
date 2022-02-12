
resource "aws_instance" "ec2" {
  ami = "ami-0dd0ccab7e2801812"
  instance_type = "t2.micro"
  tags = {
    Name = "DB Server"
  }
}

output "private_ip" {
  value = aws_instance.ec2.private_ip
}
