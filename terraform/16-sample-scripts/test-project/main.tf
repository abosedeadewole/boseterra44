
module "s3" {
  source = "./s3"
 # aws_arn_dev_role = module.s3_iam_profile.S3-dev-rol-arn
  # security_group_ids = [module.sg.sg_id]
  #  vpc_id = module.vpc.vpc_id
  #  aws_region = var.region

  providers = {
    aws = aws.Account-2
  }

}

module "iam-profile" {
  source         = "./iam-profile"
  s3_iam_profile = module.s3.aws_s3_assume_role_arn
}

module "vpc" {
  source = "./vpc"
}

module "sg" {
  source     = "./sg"
  vpc_id     = module.vpc.vpc_id
  aws_region = var.region
}

module "web" {
  source             = "./web"
  availability_zone  = module.vpc.private_subnet_az
  security_group     = [module.sg.sg_id]
  subnet_id          = module.vpc.private_subnet
  subnet_id_public   = module.vpc.public_subnet
  security_group_ids = [module.sg.sg_id]
  vpc_id             = module.vpc.vpc_id
  aws_region         = var.region
  instance_profile   = module.iam-profile.aws_iam_instance_profile
  route_table =  module.vpc.route_table 
}

output "PrivateIP" {
  value = module.web.private_ip
}
