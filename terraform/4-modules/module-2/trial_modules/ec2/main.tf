data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}

resource "aws_instance" "example" {
  for_each = {
    prod = "t2.medium"
    dev  = "t2.micro"
  }
  ami                    = data.aws_ami.ubuntu.id # ami-0f19d220602031aed # change ami to amazon ami
  instance_type          = each.value
  vpc_security_group_ids = [aws_security_group.allow_traffic.id] # using resource attribute reference syntax <provider>_type.<name>.<attribute>

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello, World" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
  tags = {
    Name = "my_ec2_instance ${each.key}"
  }

}
