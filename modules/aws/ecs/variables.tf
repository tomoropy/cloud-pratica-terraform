variable "env" {
  type = string
}

variable "slack_metrics_api" {
  type = object({
    task_definition_arn = string
    security_group_id   = string
    subnet_ids          = list(string)
    load_balancer_arn   = string
    capacity_provider   = string
  })
}
