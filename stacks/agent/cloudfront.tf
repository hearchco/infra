provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
  alias   = "global"
}

module "cdn_certificate" {
  source = "../../modules/acm-certificate"

  domain_name    = var.cloudfront_domain_name
  hosted_zone_id = var.hosted_zone_id

  providers = {
    aws = aws.global
  }
}

module "cdn" {
  source = "../../modules/cloudfront"

  name                = var.cloudfront_name
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = module.cdn_certificate.cert_arn
  domain_name         = var.cloudfront_domain_name
  price_class         = var.cloudfront_price_class

  origins = [
    {
      origin_id   = local.api_gateway_origin_id
      origin_type = "custom"
      domain_name = var.apigateway_domain_name
    }
  ]

  default_cache = var.cloudfront_default_cache
  ordered_cache_behaviors = [
    for path_pattern, paths_cache in var.cloudfront_custom_paths_cache : {
      path_pattern     = path_pattern
      target_origin_id = local.api_gateway_origin_id
      allowed_methods  = paths_cache.allowed_methods
      cached_methods   = paths_cache.cached_methods
      policy           = paths_cache.policy
    }
  ]

  providers = {
    aws = aws.global
  }
}
