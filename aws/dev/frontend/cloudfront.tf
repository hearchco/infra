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
  price_class         = "PriceClass_100"

  top_level_assets = module.hearchco_s3_assets.top_level_assets

  paths_cache = {
    "/search" = {
      min_ttl     = 5   // 5 seconds
      default_ttl = 300 // 5 minutes
      max_ttl     = 300 // 5 minutes
    },
    "/healthz" = {
      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 5
    },
  }

  providers = {
    aws = aws.us-east-1-cdn
  }
}
