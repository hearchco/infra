include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "${path_relative_from_include()}/../..//stacks/agent"
}

dependency "dns" {
  config_path = "../dns"
}

locals {
  environment = include.root.locals.environment
  aws_profile = include.root.locals.aws_profile
  domain_name = include.root.locals.domain_name

  domain_name_cloudfront  = "api.${local.domain_name}"
  domain_name_api_gateway = "gateway.${local.domain_name_cloudfront}"

  aws_regions = [
    "eu-central-1",
    "eu-west-1",
    "us-east-1"
  ]

  cloudfront_default_cache_behavior = {
    cache_policy = {
      min_ttl     = "60"
      default_ttl = "3600"
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
      path_pattern    = "/suggestions"
      allowed_methods = ["GET", "HEAD", "OPTIONS", "DELETE", "POST", "PUT", "PATCH"]
      cached_methods  = ["GET", "HEAD"]
      cache_policy = {
        min_ttl     = "300"
        default_ttl = "3600"
        max_ttl     = "86400"
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
    },
    {
      path_pattern    = "/exchange"
      allowed_methods = ["GET", "HEAD", "OPTIONS", "DELETE", "POST", "PUT", "PATCH"]
      cached_methods  = ["GET", "HEAD"]
      cache_policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    },
    {
      path_pattern = "/currencies"
      cache_policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    }
  ]

  apigateway_routes = [for behavior in local.cloudfront_ordered_cache_behaviors : behavior.path_pattern]

  lambda_environment = {
    "HEARCHCO_SERVER_FRONTENDURLS" = "http://localhost:5173,https://*${local.domain_name}"
  }
}

generate "main" {
  path      = "main.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
%{for region in local.aws_regions~}
# Generated resources for region: ${region}
${templatefile(
  "${path_relative_from_include()}/../..//stacks/agent/main.tf.tpl",
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

  cloudfront_name                    = "hearchco-api-cloudfront-${local.environment}"
  cloudfront_domain_name             = local.domain_name_cloudfront
  cloudfront_price_class             = "PriceClass_All"
  cloudfront_default_cache_behavior  = local.cloudfront_default_cache_behavior
  cloudfront_ordered_cache_behaviors = local.cloudfront_ordered_cache_behaviors

  apigateway_name        = "hearchco-api-api-gateway-${local.environment}"
  apigateway_domain_name = local.domain_name_api_gateway
  apigateway_routes      = local.apigateway_routes

  lambda_src_filepath    = "./tmp/bootstrap"
  lambda_src_bucket_name = "hearchco-api-lambda-src-${local.environment}"
  lambda_name            = "hearchco-api-lambda-${local.environment}"
  lambda_architecture    = "arm64"
  lambda_environment     = local.lambda_environment
}
