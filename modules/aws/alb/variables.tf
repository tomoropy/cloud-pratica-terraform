variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "security_group_id" {
  type = string
}

variable "acm_arn" {
  type = string
}

variable "domain" {
  type = string
}

variable "arn_target_group_slack_metrics" {
  type = string
}
