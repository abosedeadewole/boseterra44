data "aws_ami" "amzlinux" {
  most_recent = true
  owners      = ["amazon"]
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



resource "aws_instance" "web" {
  ami                    = data.aws_ami.amzlinux.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.test.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2-resources-iam-profile.id 

tags = {
    Name = var.instance_name
  }
}

resource "aws_key_pair" "test" {
  key_name = "testing"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/rNYn6Q1Xu1ZhrxwPGTVLfM96DfbHq2rQYfG5niZDdmjTCpMLpq1O5vd4Hwo3lsxZPGz8JBnM08sV7VB1fdxV97tSPv4mDh0BV8Ly11rQO6ch0svM+8r6pVLxMMz3RU5Q9b2C8LQe32CDbtJJCJh8gw8AkTHXaSt9eP6R/w63xxIYphYgqKNMKCAM8/rIPgipfaQFiRsWTOvqWhlRlRY+8yjSacXMtkLLqXXRLptw7LiOTftwdk0DRVO82EsvfnsRe+FA0CYVkTVimqqAwVkSkQIDfHtzPWwYZJvlyzNpa17MQYsJ3FkNB96J59DAWRTdLwosyB4MY4q+9d025VPOGux7JCIIqCq5ct1jj9fvLlP4JznPUgl9x6yaCglUX0sXyCB35/WPClvOERHuTzLABZL73ruEtJh5XGDXdrUPdpJLzIR/w//2cwG78/bhMvYPkaIoQcrm1LUHCfMLDhrqKygWswEo79cgHYjGeJhI2/pPdwHXLhoxg8FEZIbFJQs= ubuntu@ip-172-31-29-100"
}

variable "instance_type" {
  description = "Type of Instance"
  default = "t2.micro"
}

variable "instance_name" {
  description = "Type of Instance"
  default = "testing-instance"
}

output "public_ip" {
  value = aws_instance.web.public_ip
}

resource "aws_iam_role" "S3-Read-write-Role" {
name        = "S3-Read-write-Role"
description = "giving required permissions to EC2 instance to read and write into an s3 bucket"
assume_role_policy = "${file("./ec2-instance/assume-policy.json")}"

tags = {
Name = "S3-Read-write-Role"
}
}

resource "aws_iam_role_policy_attachment" "ec2-resources-ssm-policy-test" {
role       = aws_iam_role.S3-Read-write-Role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "ec2-resources-iam-profile" {
name = "s3-read-access-only"
role = aws_iam_role.S3-Read-write-Role.name

}

output "iam-role-arn" {
  value = aws_iam_role.S3-Read-write-Role.arn
}

output "instance-profile-arn" {
  value = aws_iam_instance_profile.ec2-resources-iam-profile.arn
}

