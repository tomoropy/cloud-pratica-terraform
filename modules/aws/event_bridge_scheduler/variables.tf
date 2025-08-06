variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "slack_metrics" {
  type = object({
    iam_role_arn                             = string
    ecs_cluster_arn                          = string
    ecs_task_definition_arn_without_revision = string
    security_group_id                        = string
  })
}

variable "cost_cutter" {
  type = object({
    enable                                = bool
    iam_role_arn                          = string
    ec2_instance_ids                      = list(string)
    ecs_cluster_arn_cloud_pratica_backend = string
  })
}

variable "schedule_expression" {
  type    = string
  default = "cron(0 1 * * ? *)" // 毎日01:00に実行
}

locals {
  rds_identifier_cloud_pratica = "cloud-pratica-${var.env}"
}
