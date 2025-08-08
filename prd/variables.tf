locals {
  env                    = "prd"
  account_id             = "837217115231"
  region                 = "ap-northeast-1"
  domain                 = "tomoropy.com"
  slack_metrics_host     = "sm.${local.domain}"
  slack_metrics_api_host = "sm-api.${local.domain}"
  public_subnet_ids = [
    module.subnet.id_public_subnet_1a,
    module.subnet.id_public_subnet_1c
  ]
  private_subnet_ids = [
    module.subnet.id_private_subnet_1a,
    module.subnet.id_private_subnet_1c
  ]
  public_subnet_cidr_blocks = [
    module.subnet.cidr_block_public_subnet_1a,
    module.subnet.cidr_block_public_subnet_1a
  ]
  private_subnet_cidr_blocks = [
    module.subnet.cidr_block_private_subnet_1a,
    module.subnet.cidr_block_private_subnet_1c
  ]
}
