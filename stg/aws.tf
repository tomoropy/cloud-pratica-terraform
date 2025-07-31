module "vpc" {
  source = "../modules/aws/vpc"
  env    = local.env
}

module "subnet" {
  source = "../modules/aws/subnet"
  env    = local.env
  vpc_id = module.vpc.vpc_id
}

module "igw" {
  source = "../modules/aws/internet_gateway"
  env    = local.env
  vpc_id = module.vpc.vpc_id
}

module "route_table" {
  source               = "../modules/aws/route_table"
  env                  = local.env
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.igw.igw_id
  network_interface_id = "eni-0aedab9cb031ef16f"
  public_subnet_ids    = local.public_subnet_ids
  private_subnet_ids   = local.private_subnet_ids
}
