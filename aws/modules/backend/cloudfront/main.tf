locals {
  origin_id = "api-gateway"
}

resource "aws_cloudfront_distribution" "api_gateway_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  aliases             = [var.domain_name]

  origin {
    origin_id   = local.origin_id
    domain_name = var.target_domain_name

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.paths
    content {
      path_pattern           = ordered_cache_behavior.key
      allowed_methods        = var.allowed_methods
      cached_methods         = var.cached_methods
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"
      min_ttl                = ordered_cache_behavior.value.min_ttl
      default_ttl            = ordered_cache_behavior.value.default_ttl
      max_ttl                = ordered_cache_behavior.value.max_ttl
      compress               = true

      forwarded_values {
        query_string = true
        cookies {
          forward = "none"
        }
      }
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.acm_certificate_arn
    ssl_support_method  = "sni-only"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
