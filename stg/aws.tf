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
  source            = "../modules/aws/route_table"
  env               = local.env
  vpc_id            = module.vpc.vpc_id
  igw_id            = module.igw.igw_id
  public_subnet_ids = local.public_subnet_ids
}

# import {
#   to = module.route_table.aws_route_table_association.public["subnet-0623c4caf5c69c50d"]
#   id = "subnet-0623c4caf5c69c50d/rtb-0eab1e8ac1bbb5488"
# }

# import {
#   to = module.route_table.aws_route_table_association.public["subnet-0692619d9b315e4b5"]
#   id = "subnet-0692619d9b315e4b5/rtb-0eab1e8ac1bbb5488"
# }

