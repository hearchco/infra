resource "aws_cloudfront_origin_request_policy" "default_origin_request_policy" {
  name = "${var.name}-default-origin-request-policy"

  cookies_config {
    cookie_behavior = "none"
  }

  headers_config {
    header_behavior = var.header_behavior
    headers {
      items = var.header_items
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
      header_behavior = var.header_behavior
      headers {
        items = var.header_items
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_cache_policy" "s3_static_default_cache_policy" {
  count = var.s3_static_default_cache != null ? 1 : 0

  name        = "${var.name}-cache-policy-assets"
  min_ttl     = var.s3_static_default_cache.min_ttl
  default_ttl = var.s3_static_default_cache.default_ttl
  max_ttl     = var.s3_static_default_cache.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = var.header_behavior
      headers {
        items = var.header_items
      }
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_cache_policy" "custom_cache_policy" {
  for_each = var.custom_paths_cache

  name        = "${var.name}-cache-policy${replace(each.key, "/", "-")}"
  min_ttl     = each.value.min_ttl
  default_ttl = each.value.default_ttl
  max_ttl     = each.value.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = var.header_behavior
      headers {
        items = var.header_items
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}
