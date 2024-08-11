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

  default_paths_cache = {
    min_ttl     = "60"
    default_ttl = "3600"
    max_ttl     = "86400"
  }

  all_allowed_methods  = ["HEAD", "GET", "OPTIONS", "DELETE", "POST", "PUT", "PATCH"]
  less_allowed_methods = ["HEAD", "GET", "OPTIONS"]

  all_cached_methods  = ["HEAD", "GET", "OPTIONS"]
  less_cached_methods = ["HEAD", "GET"]

  paths_cache = {
    "/healthz" = {
      allowed_methods = local.less_allowed_methods
      cached_methods  = local.less_cached_methods
      policy = {
        min_ttl     = "5"
        default_ttl = "5"
        max_ttl     = "5"
      }
    },
    "/versionz" = {
      allowed_methods = local.less_allowed_methods
      cached_methods  = local.less_cached_methods
      policy = {
        min_ttl     = "60"
        default_ttl = "60"
        max_ttl     = "60"
      }
    },
    "/suggestions" = {
      allowed_methods = local.all_allowed_methods
      cached_methods  = local.all_cached_methods
      policy = {
        min_ttl     = "300"
        default_ttl = "3600"
        max_ttl     = "86400"
      }
    },
    "/search" = {
      allowed_methods = local.all_allowed_methods
      cached_methods  = local.all_cached_methods
      policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    },
    "/exchange" = {
      allowed_methods = local.all_allowed_methods
      cached_methods  = local.all_cached_methods
      policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    },
    "/currencies" = {
      allowed_methods = local.less_allowed_methods
      cached_methods  = local.less_cached_methods
      policy = {
        min_ttl     = "300"
        default_ttl = "86400"
        max_ttl     = "86400"
      }
    },
  }
  paths_without_cache = [for path, _ in local.paths_cache : path]

  lambda_environment = {}
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

  cloudfront_name               = "hearchco-api-cloudfront-${local.environment}"
  cloudfront_domain_name        = local.domain_name_cloudfront
  cloudfront_price_class        = "PriceClass_All"
  cloudfront_default_cache      = local.default_paths_cache
  cloudfront_custom_paths_cache = local.paths_cache

  apigateway_name        = "hearchco-api-api-gateway-${local.environment}"
  apigateway_domain_name = local.domain_name_api_gateway
  apigateway_routes      = local.paths_without_cache

  lambda_src_filepath    = "./tmp/bootstrap"
  lambda_src_bucket_name = "hearchco-api-lambda-src-${local.environment}"
  lambda_name            = "hearchco-api-lambda-${local.environment}"
  lambda_architecture    = "arm64"
  lambda_environment     = local.lambda_environment
}
