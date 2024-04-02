# To create a new region copy this file and rename it to the region name.
# Afterwards use Find and Replace to replace all occurrences "eu-west-3" with the new region name.
# Lastly, use Find and Replace to replace all occurrences "eu_west_3" with the new region name.
# Don't forget to add replication to the main S3 bucket for the new region in locals.tf!

provider "aws" {
  profile = local.profile
  region  = "eu-west-3"
  alias   = "eu-west-3"
}

module "hearchco_s3_eu_west_3" {
  source        = "../../modules/backend/s3"
  bucket_prefix = "eu-west-3"
  replica       = true

  providers = {
    aws = aws.eu-west-3
  }
}

module "hearchco_lambda_eu_west_3" {
  source           = "../../modules/backend/lambda"
  role             = module.lambda_iam.role_arn
  s3_bucket        = module.hearchco_s3_eu_west_3.bucket_id
  s3_key           = module.hearchco_s3_eu_west_3.s3_key
  source_code_hash = module.hearchco_s3_eu_west_3.source_code_hash
  environment      = local.environment
  proxy_salt       = local.proxy_salt

  providers = {
    aws = aws.eu-west-3
  }
}

module "hearchco_certificate_eu_west_3" {
  source         = "../../modules/backend/acm"
  domain_name    = local.api_domain_name
  hosted_zone_id = module.hearchco_route53.hosted_zone_id

  providers = {
    aws = aws.eu-west-3
  }
}

module "hearchco_apigateway_eu_west_3" {
  source              = "../../modules/backend/apigateway"
  domain_name         = local.api_domain_name
  hosted_zone_id      = module.hearchco_route53.hosted_zone_id
  acm_certificate_arn = module.hearchco_certificate_eu_west_3.cert_arn
  function_name       = module.hearchco_lambda_eu_west_3.function_name
  invoke_arn          = module.hearchco_lambda_eu_west_3.invoke_arn
  routes              = local.routes

  providers = {
    aws = aws.eu-west-3
  }
}
