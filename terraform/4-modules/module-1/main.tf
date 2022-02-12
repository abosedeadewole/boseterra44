terraform {
  
}

module "submodules" {
  source = ".//submodules"
  instance_type = "t2.micro"
}

output "public_ip_address" {
  value = module.submodules.public_ip_address 
}