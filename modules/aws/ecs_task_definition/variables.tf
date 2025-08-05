variable "env" {
  type = string
}

variable "ecs_task_specs" {
  type = object({
    db_migrator = object({
      cpu    = string
      memory = string
    })
    slack_metrics_api = object({
      cpu    = string
      memory = string
    })
    slack_metrics_batch = object({
      cpu    = string
      memory = string
    })
  })
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn_db_migrator" {
  type = string
}

variable "ecs_task_role_arn_slack_metrics" {
  type = string
}

variable "secrets_manager_arn_db_main_instance" {
  type = string
}

variable "ecr_url_db_migrator" {
  type = string
}

variable "ecr_url_slack_metrics" {
  type = string
}

variable "arn_cp_config_bucket" {
  type = string
}
