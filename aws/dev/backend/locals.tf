locals {
  # Provider
  profile = "891377085136_Admin"

  # Cloudfront
  cdn_domain_name = "dev.api.hearch.co"

  # S3
  buckets_to_replicate = tomap({
    "us-east-1" : module.hearchco_s3_us_east_1.bucket_arn,
    "eu-west-3" : module.hearchco_s3_eu_west_3.bucket_arn,
  })

  # Lambda
  environment = tomap({
    HEARCHCO_SERVER_FRONTENDURLS = "http://localhost:5173,https://*hearch.co,https://*hearchco-frontend.pages.dev"
    HEARCHCO_SERVER_CACHE_TYPE   = "none" # currently caching has some bugs so it's disabled
  })
  # Not inside environment because it's a secret
  proxy_salt = module.salt.string

  # API Gateway
  api_domain_name = "gateway.${local.cdn_domain_name}"
  routes = toset([
    "/search",
    "/proxy",
  ])
}
