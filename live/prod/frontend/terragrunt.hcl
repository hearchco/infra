include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}/../..//stacks/frontend"
}

dependency "dns" {
  config_path = "../dns"
}

locals {
  aws_profile = include.root.locals.aws_profile
  aws_regions = include.root.locals.aws_regions
  environment = include.root.locals.environment
  domain_name = include.root.locals.domain_name

  domain_name_cloudfront      = local.domain_name
  domain_name_api_gateway     = "gateway.${local.domain_name_cloudfront}"
  api_domain_name_cloudfront  = "api.${local.domain_name}"
  api_domain_name_api_gateway = "gateway.${local.api_domain_name_cloudfront}"

  cloudfront_default_cache_behavior = {
    cache_policy = {
      min_ttl     = 86400 // 1 day
      default_ttl = 86400 // 1 day
      max_ttl     = 86400 // 1 day
    }
  }

  cloudfront_all_methods = ["GET", "HEAD", "OPTIONS", "DELETE", "POST", "PUT", "PATCH"]
  cloudfront_s3_static_cache_behavior = {
    cache_policy = {
      min_ttl     = 2592000 // 30 days
      default_ttl = 2592000 // 30 days
      max_ttl     = 2592000 // 30 days
    }
  }
  cloudfront_ordered_cache_behaviors = [
    {
      path_pattern = "/healthz"
      cache_policy = {
        min_ttl     = 1 // 1 second
        default_ttl = 1 // 1 second
        max_ttl     = 1 // 1 second
      }
    },
    {
      path_pattern = "/"
      cache_policy = {
        min_ttl     = 86400 // 1 day
        default_ttl = 86400 // 1 day
        max_ttl     = 86400 // 1 day
      }
    },
    {
      path_pattern    = "/opensearch.xml"
      allowed_methods = local.cloudfront_all_methods
      cache_policy = {
        min_ttl     = 86400 // 1 day
        default_ttl = 86400 // 1 day
        max_ttl     = 86400 // 1 day
      }
    },
    {
      path_pattern    = "/search"
      allowed_methods = local.cloudfront_all_methods
      cache_policy = {
        min_ttl     = 1 // 1 second
        default_ttl = 1 // 1 second
        max_ttl     = 1 // 1 second
      }
    }
  ]

  apigateway_routes = [for behavior in local.cloudfront_ordered_cache_behaviors : behavior.path_pattern]

  lambda_environment = {}
}

generate "main" {
  path      = "main.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for region in local.aws_regions~}
# Generated resources for region: ${region}
${templatefile(
  "${path_relative_from_include()}/../..//stacks/frontend/main.tf.tpl",
  {
    profile            = "${local.aws_profile}"
    region_dashed      = "${region}",
    region_underscored = replace("${region}", "-", "_")
  }
)}
%{endfor~}
EOF
}

inputs = {
  aws_profile    = local.aws_profile
  hosted_zone_id = dependency.dns.outputs.hosted_zone_id
  release_tag    = "v0.22.0"

  cloudfront_name                     = "hearchco-ssr-cloudfront-${local.environment}"
  cloudfront_domain_name              = local.domain_name_cloudfront
  cloudfront_price_class              = "PriceClass_All"
  cloudfront_default_cache_behavior   = local.cloudfront_default_cache_behavior
  cloudfront_s3_static_cache_behavior = local.cloudfront_s3_static_cache_behavior
  cloudfront_ordered_cache_behaviors  = local.cloudfront_ordered_cache_behaviors

  apigateway_name        = "hearchco-ssr-api-gateway-${local.environment}"
  apigateway_domain_name = local.domain_name_api_gateway
  apigateway_routes      = local.apigateway_routes

  lambda_src_bucket_name               = "hearchco-ssr-lambda-src-${local.environment}"
  lambda_name                          = "hearchco-ssr-lambda-${local.environment}"
  lambda_agent_api_gateway_domain_name = local.api_domain_name_api_gateway
  lambda_agent_cloudfront_domain_name  = local.api_domain_name_cloudfront
  lambda_environment                   = local.lambda_environment
  lambda_keep_warm                     = true

  s3_bucket_name        = "hearchco-ssr-s3-static-${local.environment}"
  s3_static_assets_path = "./tmp/hearchco_s3_assets_aws"
}
