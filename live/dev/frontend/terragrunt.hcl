include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}/../..//stacks/frontend-edge"
}

dependency "dns" {
  config_path = "../dns"
}

locals {
  environment = include.root.locals.environment
  aws_profile = include.root.locals.aws_profile
  domain_name = include.root.locals.domain_name

  domain_name_cloudfront      = local.domain_name
  api_domain_name_cloudfront  = "api.${local.domain_name}"
  api_domain_name_api_gateway = "gateway.${local.api_domain_name_cloudfront}"

  cloudfront_default_cache_behavior = {
    cache_policy = {
      min_ttl     = "60"
      default_ttl = "3600"
      max_ttl     = "86400"
    }
  }

  cloudfront_s3_static_cache_behavior = {
    cache_policy = {
      min_ttl     = "3600"
      default_ttl = "86400"
      max_ttl     = "86400"
    }
  }

  cloudfront_ordered_cache_behaviors = [
    {
      path_pattern = "/healthz"
      cache_policy = {
        min_ttl     = "5"
        default_ttl = "5"
        max_ttl     = "5"
      }
    },
    {
      path_pattern = "/versionz"
      cache_policy = {
        min_ttl     = "60"
        default_ttl = "60"
        max_ttl     = "60"
      }
    },
    {
      path_pattern    = "/search"
      allowed_methods = ["GET", "HEAD", "OPTIONS", "DELETE", "POST", "PUT", "PATCH"]
      cached_methods  = ["GET", "HEAD"]
      cache_policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    }
  ]

  lambda_environment = {
    "PUBLIC_URI"     = "https://${local.domain_name}"
    "API_URI"        = "https://${local.api_domain_name_api_gateway}"
    "PUBLIC_API_URI" = "https://${local.api_domain_name_cloudfront}"
  }
}

inputs = {
  aws_profile    = local.aws_profile
  hosted_zone_id = dependency.dns.outputs.hosted_zone_id

  cloudfront_name                     = "hearchco-ssr-cloudfront-${local.environment}"
  cloudfront_domain_name              = local.domain_name_cloudfront
  cloudfront_price_class              = "PriceClass_All"
  cloudfront_cf_function_path         = "./tmp/cloudfront/index.js"
  cloudfront_default_cache_behavior   = local.cloudfront_default_cache_behavior
  cloudfront_s3_static_cache_behavior = local.cloudfront_s3_static_cache_behavior
  cloudfront_ordered_cache_behaviors  = local.cloudfront_ordered_cache_behaviors

  lambda_src_filepath    = "./tmp/lambda/index.mjs"
  lambda_src_bucket_name = "hearchco-ssr-lambda-src-${local.environment}"
  lambda_name            = "hearchco-ssr-lambda-${local.environment}"
  lambda_environment     = local.lambda_environment

  s3_bucket_name        = "hearchco-ssr-s3-static-${local.environment}"
  s3_static_assets_path = "./tmp/s3"
}
