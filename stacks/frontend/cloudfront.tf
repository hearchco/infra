module "cdn_certificate" {
  source = "../../modules/acm-certificate"

  domain_name    = var.cloudfront_domain_name
  hosted_zone_id = var.hosted_zone_id
}

module "cdn" {
  source = "../../modules/cloudfront"

  name        = var.cloudfront_name
  origin_type = "s3"

  domain_name         = var.cloudfront_domain_name
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = module.cdn_certificate.cert_arn
  price_class         = var.cloudfront_price_class

  target_domain_name         = module.s3_static_assets_bucket.bucket_domain_name
  s3_static_oai_id           = module.s3_static_assets_upload.oai_id
  s3_static_top_level_assets = module.s3_static_assets_upload.top_level_assets

  cf_functions = [
    {
      name          = "sveltekit-rewriter"
      src_file_path = var.cloudfront_cf_function_path
    }
  ]

  lambda_functions = [
    {
      arn = module.lambda_edge.qualified_arn
    }
  ]

  default_cache           = var.cloudfront_default_cache
  custom_paths_cache      = var.cloudfront_custom_paths_cache
  s3_static_default_cache = var.cloudfront_s3_static_default_cache
}
