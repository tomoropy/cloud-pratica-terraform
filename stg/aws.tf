module "vpc" {
  source = "../modules/aws/vpc"
  env    = local.env
}

module "subnet" {
  source = "../modules/aws/subnet"
  env    = local.env
  vpc_id = module.vpc.id_vpc
}

module "igw" {
  source = "../modules/aws/internet_gateway"
  env    = local.env
  vpc_id = module.vpc.id_vpc
}

module "route_table" {
  source               = "../modules/aws/route_table"
  env                  = local.env
  vpc_id               = module.vpc.id_vpc
  id_igw               = module.igw.id_igw
  network_interface_id = "eni-0aedab9cb031ef16f"
  public_subnet_ids    = local.public_subnet_ids
  private_subnet_ids   = local.private_subnet_ids
}

module "security_group" {
  source                     = "../modules/aws/security_group"
  env                        = local.env
  vpc_id                     = module.vpc.id_vpc
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

module "ecs" {
  source = "../modules/aws/ecs"
  env    = local.env
  slack_metrics_api = {
    task_definition_arn = module.ecs_task_definition.arn_slack_metrics_api
    security_group_id   = module.security_group.id_slack_metrics_api
    subnet_ids          = local.private_subnet_ids
    load_balancer_arn   = module.target_group.arn_target_group_slack_metrics
  }
}

module "ecs_task_definition" {
  source = "../modules/aws/ecs_task_definition"
  env    = local.env
  ecs_task_specs = {
    db_migrator = {
      cpu    = "1024"
      memory = "3072"
    }
    slack_metrics_api = {
      cpu    = "256"
      memory = "512"
    }
    slack_metrics_batch = {
      cpu    = "1024"
      memory = "3072"
    }
  }
  arn_ecs_task_execution_role          = module.iam_role.arn_ecs_task_execution_role
  arn_ecs_task_role_arn_db_migrator    = module.iam_role.arn_ecs_task_role_arn_db_migrator
  arn_ecs_task_role_arn_slack_metrics  = module.iam_role.arn_ecs_task_role_arn_slack_metrics
  secrets_manager_arn_db_main_instance = module.secrets_manager.arn_db_main_instance
  ecr_url_db_migrator                  = "${module.ecr.url_db_migrator}:1ab283b"   // 一旦ハードコード（のちにespressoでリファクタ予定）
  ecr_url_slack_metrics                = "${module.ecr.url_slack_metrics}:1ab283b" // 一旦ハードコード（のちにespressoでリファクタ予定）
  arn_cp_config_bucket                 = "arn:aws:s3:::cp-tomohiro-kawauchi-config-${local.env}"
}

module "event_bridge_scheduler" {
  source = "../modules/aws/event_bridge_scheduler"
  env    = local.env
  slack_metrics = {
    iam_role_arn                             = module.iam_role.arn_ecs_task_role_arn_scheduler_slack_metrics
    ecs_cluster_arn                          = module.ecs.ecs_cluster_arn
    ecs_task_definition_arn_without_revision = module.ecs_task_definition.arn_without_revision_slack_metrics_batch
    security_group_id                        = module.security_group.id_slack_metrics_api
  }
  cost_cutter = {
    enable                                = true
    iam_role_arn                          = module.iam_role.arn_iam_role_arn_scheduler_cost_cutter
    ec2_instance_ids                      = toset([module.ec2.id_bastion, module.ec2.id_nat])
    ecs_cluster_arn_cloud_pratica_backend = module.ecs.ecs_cluster_arn
  }
  subnet_ids = local.private_subnet_ids
}

module "target_group" {
  source = "../modules/aws/target_group"
  env    = local.env
  vpc_id = module.vpc.id_vpc
}

module "alb" {
  source                         = "../modules/aws/alb"
  env                            = local.env
  subnet_ids                     = local.public_subnet_ids
  security_group_id              = module.security_group.id_alb
  acm_arn                        = module.acm_tomoropy_com_ap_northeast_1.arn_acm_unit
  domain                         = local.domain
  arn_target_group_slack_metrics = module.target_group.arn_target_group_slack_metrics
}

module "s3" {
  source = "../modules/aws/s3"
  env    = local.env
  slack_metrics = {
    cloudfront_distribution_arn = module.cloudfront.arn_cloudfront_distribution
  }
}

module "cloudfront" {
  source              = "../modules/aws/cloudfront"
  env                 = local.env
  domain              = local.domain
  amplify_domain      = "develop.d33ekurvlhumfe.amplifyapp.com"
  acm_certificate_arn = module.acm_tomoropy_com_us_east_1.arn_acm_unit
}

module "route53" {
  source = "../modules/aws/route53_unit"
  env    = local.env
  domain = local.domain
  records = [
    // slack-metrics-clinet(Amplify)
    {
      name = "${local.slack_metrics_host}"
      type = "A"
      alias = {
        name                   = module.cloudfront.domain_name_slack_metrics_client
        zone_id                = module.cloudfront.zone_id_us_east_1
        evaluate_target_health = false
      }
    },
    // slack-metrics-api(ECS)
    {
      name = "${local.slack_metrics_api_host}"
      type = "A"
      alias = {
        name                   = "dualstack.${module.alb.alb_dns_name_tomoropy_com}"
        zone_id                = module.alb.zone_id_ap_northeast_1
        evaluate_target_health = true
      }
    },
    // ACMの検証用
    {
      name   = module.acm_tomoropy_com_ap_northeast_1.validation_record_name
      values = [module.acm_tomoropy_com_ap_northeast_1.validation_record_value]
      type   = "CNAME"
      ttl    = "300"
    },
  ]
  ses = {
    enable      = true
    dkim_tokens = module.ses.dkim_tokens_tomoropy_com
  }
}
