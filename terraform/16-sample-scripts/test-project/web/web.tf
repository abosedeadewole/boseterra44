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


data "template_file" "userdata" {
  template = file("./web/server.sh")
}


# instance in public subent 
resource "aws_instance" "web2-to-delete" {
  ami                    = data.aws_ami.amzlinux.image_id
  instance_type          = var.Instance_Type
  key_name               = aws_key_pair.ec2-demo.key_name
  vpc_security_group_ids = var.security_group 
  user_data              = data.template_file.userdata.rendered
  iam_instance_profile   = var.instance_profile
  subnet_id              = var.subnet_id_public

root_block_device {
delete_on_termination = true
volume_type           = "gp2"
volume_size           = 20 
}

tags = {
    Name = var.Instance_Name
  }
}


resource "aws_instance" "web" {
  ami                    = data.aws_ami.amzlinux.image_id
  instance_type          = var.Instance_Type
  key_name               = aws_key_pair.ec2-demo.key_name
  vpc_security_group_ids = var.security_group 
  user_data              = data.template_file.userdata.rendered
  iam_instance_profile   = var.instance_profile
  subnet_id              = var.subnet_id

root_block_device {
delete_on_termination = true
volume_type           = "gp2"
volume_size           = 20 
}

tags = {
    Name = var.Instance_Name
  }
}

resource "aws_key_pair" "ec2-demo" {
  key_name   = "demo-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDLLdJq8QTirT3Sp9VicLIYtLDtmw9ahx5Id3/5RkEJM7fCwgHWEcD7ZE5iumUcja9P+aHYD7basXOJbHaNYNZqHf+kdFQkslbUjSUI6EjJg3NdmajF/imnif5NVeIzKxrMdtuUz54ZM5bG8z3O5JtMRrT1Bqy4YgcLyv34duGs5eCUcBpxqY1eNYHt1J5ci1IgfIplD+SKXd7eqkbZIUrpE5yh8LuaPdpteAFMVgkSlKdI3FIOPAYBSdEb0QdlHsnXh6D5BzEg1kFgxAttwjo3CYl5Ni+AUFwmWH1pLXK0fLe7gvaaAiFMGNdNL60YB6DiKmhYHNWAAZ/iBXZCq9v+LFXJnD/c5ByAhgpJ9T1271+w3K3y2+jDJUn8qFZOdbUQ8COR72tX84ENe6FVNl52MPZ6bvA+CyOO7eKDVuTC3RjmMCdRaj3KlCsymy7fshhoyv3aoZH4JJgEo0rCSF9p/mtdARVnhLJOojr57utuyqlEDdz7E+ACS2Owo97aR0s= milua@ip-172-31-29-100"
}


resource "aws_vpc_endpoint" "ssm_endpoint" {
  
  vpc_id            = var.vpc_id #aws_vpc.metadata_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm"
  subnet_ids        = [ var.subnet_id ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids  = var.security_group_ids # [ module.sg.sg_id]
  
  tags = {
    Name = "ssm-test"
    Environment = "ssm-test"
  }

}

resource "aws_vpc_endpoint" "ssm_messages" {
  
  vpc_id            = var.vpc_id #aws_vpc.metadata_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssmmessages"
  subnet_ids        = [ var.subnet_id ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids  = var.security_group_ids # [ module.sg.sg_id]
  
  tags = {
    Name = "ssm-messages"
    Environment = "ssm-messages"
  }

}
resource "aws_vpc_endpoint" "ssm_ssm-incidents" {
  
  vpc_id            = var.vpc_id #aws_vpc.metadata_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.ssm-incidents"
  subnet_ids        = [ var.subnet_id ]
  vpc_endpoint_type = "Interface"
  private_dns_enabled = true

  security_group_ids  = var.security_group_ids # [ module.sg.sg_id]
  
  tags = {
    Name = "ssm-incidents"
    Environment = "ssm-incidents"
  }

}

/*
variable "security_group_ids" {
  description = "value"
  type = set(string)
}

variable "vpc_id" {
  description = ""
  type = string
}

variable "aws_region" {
  description = "value"
  type = string
}
*/

resource "aws_vpc_endpoint" "s3_endpoint" {
  
  vpc_id            = var.vpc_id #aws_vpc.metadata_vpc.id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
 # vpc_endpoint_type =  "Gateway"  # "Gateway" "Interface"
  # route_table_ids   = var.route_table
 # security_group_ids  = var.security_group_ids # [ module.sg.sg_id]
 # subnet_ids = [var.subnet_id ]
  tags = {
    Environment = "test"
  }

}

resource "aws_vpc_endpoint_route_table_association" "s3-endpoint-example" {
  route_table_id  = var.route_table 
  vpc_endpoint_id = aws_vpc_endpoint.s3_endpoint.id
}

output "endpoints" {
  description = "Array containing the full resource object and attributes for all endpoints created"
  value       = aws_vpc_endpoint.s3_endpoint
}


output "private_ip" {
  value = aws_instance.web.private_ip
}

