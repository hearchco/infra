resource "aws_cloudfront_origin_request_policy" "default_origin_request_policy" {
  name = "${var.name}-default-origin-request-policy"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = var.origin_header_behavior
    headers {
      items = var.origin_header_items
    }
  }

  query_strings_config {
    query_string_behavior = "all"
  }
}

resource "aws_cloudfront_cache_policy" "default_cache_policy" {
  name        = "${var.name}-default-cache-policy"
  min_ttl     = var.default_cache.min_ttl
  default_ttl = var.default_cache.default_ttl
  max_ttl     = var.default_cache.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = var.cache_header_behavior
      headers {
        items = var.cache_header_items
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_cache_policy" "ordered_cache_policy" {
  for_each = { for cache_behavior in var.ordered_cache_behaviors : local.cache_policy_names_map[cache_behavior.path_pattern] => cache_behavior.policy... }

  name        = "${var.name}-cache-policy-${each.key}"
  min_ttl     = each.value[0].min_ttl
  default_ttl = each.value[0].default_ttl
  max_ttl     = each.value[0].max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = var.cache_header_behavior
      headers {
        items = var.cache_header_items
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}
