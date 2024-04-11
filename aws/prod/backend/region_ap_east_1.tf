# To create a new region copy this file and rename it to the region name.
# Afterwards use Find and Replace to replace all occurrences "ap-east-1" with the new region name.
# Lastly, use Find and Replace to replace all occurrences "ap_east_1" with the new region name.

provider "aws" {
  profile = var.aws_profile
  region  = "ap-east-1"
  alias   = "ap-east-1"
}

module "hearchco_s3_ap_east_1" {
  source = "../../modules/backend/s3"

  providers = {
    aws = aws.ap-east-1
  }
}

module "hearchco_lambda_ap_east_1" {
  source           = "../../modules/backend/lambda"
  role             = module.lambda_iam.role_arn
  s3_bucket        = module.hearchco_s3_ap_east_1.bucket_id
  s3_key           = module.hearchco_s3_ap_east_1.s3_key
  source_code_hash = module.hearchco_s3_ap_east_1.source_code_hash
  environment      = local.environment
  proxy_salt       = local.proxy_salt

  providers = {
    aws = aws.ap-east-1
  }
}

module "hearchco_certificate_ap_east_1" {
  source         = "../../modules/backend/acm"
  domain_name    = local.api_gateway_domain_name
  hosted_zone_id = data.aws_route53_zone.hearchco_route53.zone_id

  providers = {
    aws = aws.ap-east-1
  }
}

module "hearchco_apigateway_ap_east_1" {
  source              = "../../modules/backend/apigateway"
  domain_name         = local.api_gateway_domain_name
  hosted_zone_id      = data.aws_route53_zone.hearchco_route53.zone_id
  acm_certificate_arn = module.hearchco_certificate_ap_east_1.cert_arn
  function_name       = module.hearchco_lambda_ap_east_1.function_name
  invoke_arn          = module.hearchco_lambda_ap_east_1.invoke_arn
  routes              = local.routes

  providers = {
    aws = aws.ap-east-1
  }
}
