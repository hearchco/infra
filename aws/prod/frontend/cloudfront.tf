module "hearchco_cdn_certificate" {
  source         = "../../modules/universal/acm"
  domain_name    = var.domain_name
  hosted_zone_id = data.aws_route53_zone.hearchco_route53.zone_id

  providers = {
    aws = aws.us-east-1-cdn
  }
}

module "hearchco_cloudfront" {
  source              = "../../modules/frontend/cloudfront"
  domain_name         = var.domain_name
  hosted_zone_id      = data.aws_route53_zone.hearchco_route53.zone_id
  target_domain_name  = module.hearchco_s3_assets.bucket_domain_name
  oai_id              = module.hearchco_s3_assets.oai
  lambda_edge_arn     = module.hearchco_lambda_edge.invoke_arn
  acm_certificate_arn = module.hearchco_cdn_certificate.cert_arn
  price_class         = "PriceClass_All"

  top_level_assets = module.hearchco_s3_assets.top_level_assets

  paths_cache = {
    "/search" = {
      min_ttl     = 3600   // 1 hour
      default_ttl = 86400  // 1 day
      max_ttl     = 259200 // 3 days
    },
    "/healthz" = {
      min_ttl     = 5 // 5 seconds
      default_ttl = 5 // 5 seconds
      max_ttl     = 5 // 5 seconds
    },
  }

  providers = {
    aws = aws.us-east-1-cdn
  }
}
