# To create a new region copy this file and rename it to the region name.
# Afterwards use Find and Replace to replace all occurrences "us-east-2" with the new region name.
# Lastly, use Find and Replace to replace all occurrences "us_east_2" with the new region name.

provider "aws" {
  profile = var.aws_profile
  region  = "us-east-2"
  alias   = "us-east-2"
}

module "hearchco_s3_us_east_2" {
  source               = "../../modules/universal/s3_source_code"
  bucket_name          = "hearchco-api-binary"
  bucket_name_suffix   = module.s3_source_code_suffix.string
  filename             = module.hearchco_archiver.filename
  archive_path         = module.hearchco_archiver.output_path
  archive_base64sha256 = module.hearchco_archiver.output_base64sha256

  providers = {
    aws = aws.us-east-2
  }
}

module "hearchco_lambda_us_east_2" {
  source           = "../../modules/backend/lambda"
  role             = module.lambda_iam.role_arn
  s3_bucket        = module.hearchco_s3_us_east_2.bucket_id
  s3_key           = module.hearchco_s3_us_east_2.s3_key
  source_code_hash = module.hearchco_s3_us_east_2.source_code_hash
  environment      = local.environment
  proxy_salt       = local.proxy_salt

  providers = {
    aws = aws.us-east-2
  }
}

module "hearchco_certificate_us_east_2" {
  source         = "../../modules/universal/acm"
  domain_name    = local.api_gateway_domain_name
  hosted_zone_id = data.aws_route53_zone.hearchco_route53.zone_id

  providers = {
    aws = aws.us-east-2
  }
}

module "hearchco_apigateway_us_east_2" {
  source              = "../../modules/backend/apigateway"
  domain_name         = local.api_gateway_domain_name
  hosted_zone_id      = data.aws_route53_zone.hearchco_route53.zone_id
  acm_certificate_arn = module.hearchco_certificate_us_east_2.cert_arn
  function_name       = module.hearchco_lambda_us_east_2.function_name
  invoke_arn          = module.hearchco_lambda_us_east_2.invoke_arn
  routes              = local.routes

  providers = {
    aws = aws.us-east-2
  }
}
