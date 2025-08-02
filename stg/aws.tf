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

module "security_group" {
  source                     = "../modules/aws/security_group"
  env                        = local.env
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = local.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = local.public_subnet_cidr_blocks
}

module "ecr" {
  source = "../modules/aws/ecr"
  env    = local.env
}

module "secret_manager" {
  source = "../modules/aws/secret_manager"
  env    = local.env
}
