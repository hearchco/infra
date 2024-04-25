# To create a new region copy this file and rename it to the region name.
# Afterwards use Find and Replace to replace all occurrences "ap-northeast-2" with the new region name.
# Lastly, use Find and Replace to replace all occurrences "ap_northeast_2" with the new region name.

provider "aws" {
  profile = var.aws_profile
  region  = "ap-northeast-2"
  alias   = "ap-northeast-2"
}

module "hearchco_s3_ap_northeast_2" {
  source      = "../../modules/universal/s3_source_code"
  source_name = "bootstrap"
  bucket_name = "hearchco-api-binary"

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "hearchco_lambda_ap_northeast_2" {
  source           = "../../modules/backend/lambda"
  role             = module.lambda_iam.role_arn
  s3_bucket        = module.hearchco_s3_ap_northeast_2.bucket_id
  s3_key           = module.hearchco_s3_ap_northeast_2.s3_key
  source_code_hash = module.hearchco_s3_ap_northeast_2.source_code_hash
  environment      = local.environment
  proxy_salt       = local.proxy_salt

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "hearchco_certificate_ap_northeast_2" {
  source         = "../../modules/universal/acm"
  domain_name    = local.api_gateway_domain_name
  hosted_zone_id = data.aws_route53_zone.hearchco_route53.zone_id

  providers = {
    aws = aws.ap-northeast-2
  }
}

module "hearchco_apigateway_ap_northeast_2" {
  source              = "../../modules/backend/apigateway"
  domain_name         = local.api_gateway_domain_name
  hosted_zone_id      = data.aws_route53_zone.hearchco_route53.zone_id
  acm_certificate_arn = module.hearchco_certificate_ap_northeast_2.cert_arn
  function_name       = module.hearchco_lambda_ap_northeast_2.function_name
  invoke_arn          = module.hearchco_lambda_ap_northeast_2.invoke_arn
  routes              = local.routes

  providers = {
    aws = aws.ap-northeast-2
  }
}
