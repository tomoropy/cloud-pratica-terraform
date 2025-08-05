data "aws_ecs_task_definition" "latest_slack_metrics_api" {
  task_definition = "slack-metrics-api-${var.env}"
}

data "aws_ecs_task_definition" "latest_slack_metrics_batch" {
  task_definition = "slack-metrics-batch-${var.env}"
}

output "arn_slack_metrics_api" {
  value = data.aws_ecs_task_definition.latest_slack_metrics_api.arn
}

output "arn_without_revision_slack_metrics_batch" {
  value = data.aws_ecs_task_definition.latest_slack_metrics_batch.arn_without_revision
}
