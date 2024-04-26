locals {
  origin_id = "s3-origin"
}

resource "aws_cloudfront_distribution" "sveltekit_distribution" {
  enabled             = true
  is_ipv6_enabled     = true
  wait_for_deployment = true
  price_class         = var.price_class
  aliases             = [var.domain_name]

  origin {
    origin_id   = local.origin_id
    domain_name = var.target_domain_name

    s3_origin_config {
      origin_access_identity = "origin-access-identity/cloudfront/${var.oai_id}"
    }
  }

  default_cache_behavior {
    allowed_methods        = var.allowed_methods
    cached_methods         = var.cached_methods
    target_origin_id       = local.origin_id
    viewer_protocol_policy = "redirect-to-https"
    compress               = true
    cache_policy_id        = aws_cloudfront_cache_policy.default_cache_policy.id

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.sveltekit-rewriter.arn
    }

    lambda_function_association {
      event_type   = "origin-request"
      lambda_arn   = var.lambda_edge_arn
      include_body = true
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.top_level_assets
    content {
      path_pattern           = ordered_cache_behavior.key
      allowed_methods        = var.allowed_methods_s3
      cached_methods         = var.cached_methods_s3
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"
      compress               = true
      cache_policy_id        = aws_cloudfront_cache_policy.cache_policy_s3.id

      function_association {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.sveltekit-rewriter.arn
      }
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.paths_cache
    content {
      path_pattern           = ordered_cache_behavior.key
      allowed_methods        = var.allowed_methods
      cached_methods         = var.cached_methods
      target_origin_id       = local.origin_id
      viewer_protocol_policy = "redirect-to-https"
      compress               = true
      cache_policy_id        = aws_cloudfront_cache_policy.cache_policy[ordered_cache_behavior.key].id

      function_association {
        event_type   = "viewer-request"
        function_arn = aws_cloudfront_function.sveltekit-rewriter.arn
      }

      lambda_function_association {
        event_type   = "origin-request"
        lambda_arn   = var.lambda_edge_arn
        include_body = true
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
