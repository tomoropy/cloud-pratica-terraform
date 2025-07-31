module "vpc" {
  source = "../modules/aws/vpc"
  env    = local.env
}

module "subnet" {
  source = "../modules/aws/subnet"
  env    = local.env
  vpc_id = module.vpc.vpc_id
}

# import {
#   to = aws_subnet.private_1c
#   id = "subnet-07cc7674c331613c7"
# }
