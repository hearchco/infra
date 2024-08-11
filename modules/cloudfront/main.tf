resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  price_class         = var.price_class
  aliases             = [var.domain_name]

  dynamic "origin" {
    for_each = { for origin in var.origins : origin.origin_id => origin }
    content {
      origin_id   = origin.value.origin_id
      domain_name = origin.value.domain_name

      dynamic "custom_origin_config" {
        for_each = origin.value.origin_type == "custom" ? [1] : []
        content {
          http_port              = 80
          https_port             = 443
          origin_protocol_policy = "https-only"
          origin_ssl_protocols   = ["TLSv1.2"]
        }
      }

      dynamic "s3_origin_config" {
        for_each = origin.value.origin_type == "s3" ? [1] : []
        content {
          origin_access_identity = "origin-access-identity/cloudfront/${origin.value.s3_oai_id}"
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods
    target_origin_id       = var.default_cache_behavior.target_origin_id
    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.default_cache_policy.id

    dynamic "function_association" {
      for_each = var.default_cache_behavior.function_associations
      content {
        function_arn = aws_cloudfront_function.cf_functions[function_association.value.name].arn
        event_type   = function_association.value.event_type
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.default_cache_behavior.lambda_function_associations
      content {
        lambda_arn   = lambda_function_association.value.lambda_arn
        event_type   = lambda_function_association.value.event_type
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      target_origin_id       = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      compress               = true
      cache_policy_id        = aws_cloudfront_cache_policy.ordered_cache_policy[local.policy_names_map[ordered_cache_behavior.value.path_pattern]].id

      dynamic "function_association" {
        for_each = ordered_cache_behavior.value.function_associations
        content {
          function_arn = aws_cloudfront_function.cf_functions[function_association.value.name].arn
          event_type   = function_association.value.event_type
        }
      }

      dynamic "lambda_function_association" {
        for_each = ordered_cache_behavior.value.lambda_function_associations
        content {
          lambda_arn   = lambda_function_association.value.lambda_arn
          event_type   = lambda_function_association.value.event_type
          include_body = lambda_function_association.value.include_body
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
