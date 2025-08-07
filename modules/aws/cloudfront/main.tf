variable "env" {
  type = string
}

variable "domain" {
  type = string
}

variable "amplify_domain" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

resource "aws_cloudfront_distribution" "slack_metrics" {
  aliases         = ["sm.${var.env}.${var.domain}"]
  is_ipv6_enabled = true
  enabled         = true
  default_cache_behavior {
    allowed_methods          = ["GET", "HEAD"]
    cache_policy_id          = local.chache_policy_default_id
    cached_methods           = ["GET", "HEAD"]
    origin_request_policy_id = local.origin_request_policy_id
    target_origin_id         = "amplify-slack-metrics-${var.env}"
    viewer_protocol_policy   = "https-only"
    compress                 = true
    grpc_config {
      enabled = false
    }
  }
  ordered_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cache_policy_id        = local.chache_policy_static_id
    cached_methods         = ["GET", "HEAD"]
    path_pattern           = "/static/*"
    target_origin_id       = "s3-slack-metrics-${var.env}"
    viewer_protocol_policy = "https-only"
    compress               = true
    grpc_config {
      enabled = false
    }
  }
  origin {
    connection_attempts = 3
    connection_timeout  = 10
    origin_id           = "amplify-slack-metrics-${var.env}"
    domain_name         = var.amplify_domain
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 30
      origin_ssl_protocols     = ["TLSv1.2"]
    }
  }
  origin {
    connection_attempts      = 3
    connection_timeout       = 10
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_slack_metrics.id
    domain_name              = "cp-slack-metrics-tomohiro-kawauchi-${var.env}.s3.ap-northeast-1.amazonaws.com"
    origin_id                = "s3-slack-metrics-${var.env}"
  }
  restrictions {
    geo_restriction {
      locations        = []
      restriction_type = "none"
    }
  }
  viewer_certificate {
    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}

resource "aws_cloudfront_origin_access_control" "s3_slack_metrics" {
  name                              = "s3-slack-metrics-${var.env}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}
