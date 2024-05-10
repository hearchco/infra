resource "aws_cloudfront_cache_policy" "default_cache_policy" {
  name        = "ssr-default-cache-policy"
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
      header_behavior = "whitelist"
      headers {
        items = [
          "Accept",
          # "Accept-Encoding", # Already included
          "Accept-Language",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method",
          "Origin",
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}

resource "aws_cloudfront_cache_policy" "cache_policy_s3" {
  name        = "ssr-cache-policy-assets"
  min_ttl     = var.default_asset_cache.min_ttl
  default_ttl = var.default_asset_cache.default_ttl
  max_ttl     = var.default_asset_cache.max_ttl

  parameters_in_cache_key_and_forwarded_to_origin {
    enable_accept_encoding_brotli = true
    enable_accept_encoding_gzip   = true

    cookies_config {
      cookie_behavior = "none"
    }

    headers_config {
      header_behavior = "whitelist"
      headers {
        items = [
          "Accept",
          # "Accept-Encoding", # Already included
          "Accept-Language",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method",
          "Origin",
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_cache_policy" "cache_policy" {
  for_each = var.paths_cache

  name        = "ssr-cache-policy${replace(each.key, "/", "-")}"
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
      header_behavior = "whitelist"
      headers {
        items = [
          "Accept",
          # "Accept-Encoding", # Already included
          "Accept-Language",
          "Access-Control-Request-Headers",
          "Access-Control-Request-Method",
          "Origin",
        ]
      }
    }

    query_strings_config {
      query_string_behavior = "all"
    }
  }
}
