resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  price_class         = var.price_class
  aliases             = [var.domain_name]

  origin {
    origin_id   = local.origin_id
    domain_name = var.target_domain_name

    dynamic "custom_origin_config" {
      for_each = var.origin_type == "custom" ? [1] : []
      content {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "https-only"
        origin_ssl_protocols   = ["TLSv1.2"]
      }
    }

    dynamic "s3_origin_config" {
      for_each = var.origin_type == "s3" ? [1] : []
      content {
        origin_access_identity = "origin-access-identity/cloudfront/${var.s3_static_oai_id}"
      }
    }
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.default_cache_policy.id

    dynamic "function_association" {
      for_each = var.cf_functions
      content {
        event_type   = function_association.value.event_type
        function_arn = aws_cloudfront_function.functions[function_association.key].arn
      }
    }

    dynamic "lambda_function_association" {
      for_each = var.lambda_functions
      content {
        lambda_arn   = lambda_function_association.value.arn
        event_type   = lambda_function_association.value.event_type
        include_body = lambda_function_association.value.include_body
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.s3_static_top_level_assets
    content {
      path_pattern           = ordered_cache_behavior.key
      allowed_methods        = var.s3_static_allowed_methods
      cached_methods         = var.s3_static_cached_methods
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"
      compress               = true
      cache_policy_id        = aws_cloudfront_cache_policy.s3_static_default_cache_policy[0].id
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.custom_paths_cache
    content {
      path_pattern           = ordered_cache_behavior.key
      allowed_methods        = var.allowed_methods
      cached_methods         = var.cached_methods
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"
      compress               = true
      cache_policy_id        = aws_cloudfront_cache_policy.custom_cache_policy[ordered_cache_behavior.key].id

      dynamic "function_association" {
        for_each = var.cf_functions
        content {
          event_type   = function_association.value.event_type
          function_arn = aws_cloudfront_function.functions[function_association.key].arn
        }
      }

      dynamic "lambda_function_association" {
        for_each = var.lambda_functions
        content {
          lambda_arn   = lambda_function_association.value.arn
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
