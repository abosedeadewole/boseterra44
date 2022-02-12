
resource "aws_instance" "milua_server" {
  ami = "ami-0629230e074c580f2"
  instance_type = var.instance_type #  if you want to insert the type "t2.micro"

  tags = {
#    Name = "milua_server"
  Name = "My-sever-${local.engineer_name}" # use of interpolation
  environment =  local.environment

  }
}

