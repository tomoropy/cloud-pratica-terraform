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

module "secrets_manager" {
  source = "../modules/aws/secrets_manager"
  env    = local.env
}

module "sqs" {
  source     = "../modules/aws/sqs"
  env        = local.env
  account_id = local.account_id
}

module "ses" {
  source = "../modules/aws/ses"
  domain = local.domain
  env    = local.env
}

module "iam_role" {
  source = "../modules/aws/iam_role"
  env    = local.env
}

module "ec2" {
  source                     = "../modules/aws/ec2"
  env                        = local.env
  bastion_security_group_ids = [module.security_group.id_bastion]
  nat_security_group_ids     = [module.security_group.id_nat]
  subnet_id                  = module.subnet.id_public_subnet_1a
}

module "rds_unit" {
  source               = "../modules/aws/rds_unit"
  env                  = local.env
  identifier           = "cloud-pratica-${local.env}"
  engine_version       = "16.8"
  private_subnet_ids   = local.private_subnet_ids
  security_group_ids   = [module.security_group.id_db]
  username             = "postgres"
  db_name              = "slack_metrics"
  subnet_group_name    = "cp-db-subnet-group-${local.env}"
  parameter_group_name = "cp-db-parameter-group-${local.env}"
  family               = "postgres16"
}

module "acm_tomoropy_com_us_east_1" {
  source      = "../modules/aws/acm_unit"
  domain_name = "*.${local.env}.${local.domain}"
  providers = {
    aws = aws.us_east_1
  }
}

module "acm_tomoropy_com_ap_northeast_1" {
  source      = "../modules/aws/acm_unit"
  domain_name = "*.${local.env}.${local.domain}"
  providers = {
    aws = aws
  }
}
