locals {
  env        = "stg"
  account_id = "645437362078"
  region     = "ap-northeast-1"
  public_subnet_ids = [
    module.subnet.id_public_subnet_1a,
    module.subnet.id_public_subnet_1c
  ]
  private_subnet_ids = [
    module.subnet.id_private_subnet_1a,
    module.subnet.id_private_subnet_1c
  ]
}
