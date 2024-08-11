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
  domain_name         = var.cloudfront_domain_name
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = module.cdn_certificate.cert_arn
  price_class         = var.cloudfront_price_class

  origins = [
    {
      origin_id   = local.api_gateway_origin_id
      origin_type = "custom"
      domain_name = var.apigateway_domain_name
    }
  ]

  default_cache_behavior = {
    allowed_methods  = var.cloudfront_default_cache_behavior.allowed_methods
    cached_methods   = var.cloudfront_default_cache_behavior.cached_methods
    target_origin_id = local.api_gateway_origin_id
    cache_policy     = var.cloudfront_default_cache_behavior.cache_policy
  }

  ordered_cache_behaviors = [
    for behavior in var.cloudfront_ordered_cache_behaviors : {
      path_pattern     = behavior.path_pattern
      allowed_methods  = behavior.allowed_methods
      cached_methods   = behavior.cached_methods
      target_origin_id = local.api_gateway_origin_id
      cache_policy     = behavior.cache_policy
    }
  ]

  providers = {
    aws = aws.global
  }
}
