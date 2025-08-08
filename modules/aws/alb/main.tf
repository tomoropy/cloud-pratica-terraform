resource "aws_lb" "cp_alb" {
  load_balancer_type = "application"
  name               = "cp-alb-${var.env}"
  security_groups    = [var.security_group_id]
  subnets            = var.subnet_ids
}

resource "aws_lb_listener" "https" {
  certificate_arn   = var.acm_arn
  load_balancer_arn = aws_lb.cp_alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
  default_action {
    order            = 1
    target_group_arn = null
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "403 forbidden"
      status_code  = "403"
    }
  }
}

resource "aws_lb_listener_rule" "slack_metrics_api" {
  listener_arn = aws_lb_listener.https.arn
  action {
    order = 1
    type  = "forward"
    forward {
      stickiness {
        duration = 3600
        enabled  = false
      }
      target_group {
        arn    = var.arn_target_group_slack_metrics
        weight = 1
      }
    }
  }
  condition {
    host_header {
      values = ["sm-api.${var.domain}"]
    }
  }
}
