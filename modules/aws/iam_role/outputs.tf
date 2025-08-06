output "arn_ecs_task_execution_role" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "arn_ecs_task_role_arn_db_migrator" {
  value = aws_iam_role.db_migrator.arn
}

output "arn_ecs_task_role_arn_slack_metrics" {
  value = aws_iam_role.slack_metrics_backend.arn
}

output "arn_ecs_task_role_arn_scheduler_slack_metrics" {
  value = aws_iam_role.scheduler_slack_metrics.arn
}

output "arn_iam_role_arn_scheduler_cost_cutter" {
  value = aws_iam_role.scheduler_cost_cutter.arn
}
