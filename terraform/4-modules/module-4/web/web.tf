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

variable "instance_type" {
  type = string
}

variable "Instance_Name" {
  
}
resource "aws_instance" "web" {
  ami                    = data.aws_ami.amzlinux.image_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.variable.key_name
  security_groups = [module.sg.sg_name]
  #user_data              = file("./install_httpd.sh") #file("${path.module}/install_httpd.sh")
  user_data =  data.template_file.userdata.rendered

  tags = {
    Name = var.Instance_Name
  }
}

resource "aws_key_pair" "variable" {
  key_name   = "variable-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDNQ0FIbBeqE0V9SbKBFSw5JxLkWc5o6xQM5iJ9/YrsFMuqMWkUGRMmL3tWLEHyBDrmoWiD6tzyeO0St8LKECs4ivVBwvAFUBK/dQaXm7kFxvYatBmWTEJJwPtm7hBPCqzFcqtntVK84rB38/XakiDluckkjz3u1UbgohUMW0fqQYOK/15cZMBLkgsHetS1ukuwbgjUYCBHAspTAcF9DK8eEwOMHTf5Paty1de1vTwJEC0r2HAy+5NrY+VWf7h1HfST9UWjFJWvAqaZxTsTz5fKT3p4lBlKskw1husbR24UqsHo9vin54sMRE/DAHwq0PCvGc+b7sjJyWsqN/n9vHa1/osX//bfsBTcvMbXg1afD9W2/woLtkcDiGbAQhk049y/56nqWwntvWv188UNGTyJGRmlrGBgWyM2Otqg49tfn2nkiGJLokaP2qQWcesokbM2W0WbzQLVV5ukSY/oPcaWakdv/DIk8YdYsFOAa5I9LyhN1Du1BTzPsxwHRToIjnk= kops@ip-172-31-21-93"
}

output "pub_ip" {
  value = module.eip.Public_IP
}

module "eip" {
  source = "../eip"
  instance_id = aws_instance.web.id
}

module "sg" {
  source = "../sg"
}