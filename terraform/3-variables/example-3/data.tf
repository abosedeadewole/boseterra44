data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"] # Canonical  

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]

  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}
