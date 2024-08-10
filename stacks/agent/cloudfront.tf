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

  name        = var.cloudfront_name
  origin_type = "custom"

  domain_name         = var.cloudfront_domain_name
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = module.cdn_certificate.cert_arn
  price_class         = var.cloudfront_price_class

  target_domain_name = var.apigateway_domain_name

  default_cache      = var.cloudfront_default_cache
  custom_paths_cache = var.cloudfront_custom_paths_cache

  providers = {
    aws = aws.global
  }
}
