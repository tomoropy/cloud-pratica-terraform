resource "aws_lb_target_group" "slack_metrics_target" {
  vpc_id               = var.vpc_id
  name                 = "slack-metrics-target-${var.env}"
  deregistration_delay = "115"
  port                 = 80
  protocol             = "HTTP"
  target_type          = "ip"
  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/api/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }
}
