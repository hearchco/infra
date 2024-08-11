module "cdn_certificate" {
  source = "../../modules/acm-certificate"

  domain_name    = var.cloudfront_domain_name
  hosted_zone_id = var.hosted_zone_id

  providers = {
    aws = aws.edge
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
      origin_id   = local.s3_static_assets_origin_id
      origin_type = "s3"
      domain_name = module.s3_static_assets_bucket.bucket_domain_name
      s3_oai_id   = module.s3_static_assets_bucket.oai_id
    }
  ]

  default_cache_behavior = {
    allowed_methods  = var.cloudfront_default_cache_behavior.allowed_methods
    cached_methods   = var.cloudfront_default_cache_behavior.cached_methods
    target_origin_id = local.s3_static_assets_origin_id
    cache_policy     = var.cloudfront_default_cache_behavior.cache_policy

    function_associations = [{
      name          = "sveltekit-rewriter"
      src_file_path = var.cloudfront_cf_function_path
    }]

    lambda_function_associations = [{
      lambda_arn = module.lambda_edge.qualified_arn
    }]
  }

  ordered_cache_behaviors = concat(
    [
      for path_pattern in module.s3_static_assets_bucket.top_level_assets : {
        path_pattern     = path_pattern
        allowed_methods  = var.cloudfront_s3_static_cache_behavior.allowed_methods
        cached_methods   = var.cloudfront_s3_static_cache_behavior.cached_methods
        target_origin_id = local.s3_static_assets_origin_id
        cache_policy     = var.cloudfront_s3_static_cache_behavior.cache_policy
      }
    ],
    [
      for behavior in var.cloudfront_ordered_cache_behaviors : {
        path_pattern     = behavior.path_pattern
        allowed_methods  = behavior.allowed_methods
        cached_methods   = behavior.cached_methods
        target_origin_id = local.s3_static_assets_origin_id
        cache_policy     = behavior.cache_policy

        function_associations = [{
          name          = "sveltekit-rewriter"
          src_file_path = var.cloudfront_cf_function_path
        }]

        lambda_function_associations = [{
          lambda_arn = module.lambda_edge.qualified_arn
        }]
      }
    ]
  )

  providers = {
    aws = aws.edge
  }
}