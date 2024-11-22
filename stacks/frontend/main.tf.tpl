provider "aws" {
  profile = "${profile}"
  region  = "${region_dashed}"
  alias   = "${region_underscored}"
}

module "s3_bucket_name_suffix_${region_underscored}" {
  source = "../../modules/secret-generator"

  min_chars = 4
  max_chars = 6
  upper     = false
  special   = false
}

module "s3_src_${region_underscored}" {
  source = "../../modules/s3-src-upload"

  bucket_name          = var.lambda_src_bucket_name
  bucket_name_suffix   = module.s3_bucket_name_suffix_${region_underscored}.string
  filename             = local.lambda_src_key
  content_base64       = module.src_downloader.content_base64
  content_base64sha256 = module.src_downloader.content_base64sha256

  providers = {
    aws = aws.${region_underscored}
  }
}

module "lambda_${region_underscored}" {
  source = "../../modules/lambda"

  name = var.lambda_name
  role = module.lambda_iam.role_arn

  runtime      = var.lambda_runtime
  handler      = var.lambda_handler
  memory_size  = var.lambda_memory_size
  architecture = var.lambda_architecture
  keep_warm    = var.lambda_keep_warm

  src_s3_bucket = module.s3_src_${region_underscored}.bucket_id
  src_s3_key    = module.s3_src_${region_underscored}.s3_key
  src_hash      = module.s3_src_${region_underscored}.source_code_hash

  environment = merge(
    {
      "PUBLIC_URI"     = format("https://%s", var.cloudfront_domain_name)
      "API_URI"        = format("https://%s.%s", "${region_dashed}", var.lambda_agent_api_gateway_domain_name)
      "PUBLIC_API_URI" = format("https://%s", var.lambda_agent_cloudfront_domain_name)
    },
    local.lambda_environment
  )

  providers = {
    aws = aws.${region_underscored}
  }
}

module "apigateway_certificate_${region_underscored}" {
  source = "../../modules/acm-certificate"

  domain_name               = var.apigateway_domain_name
  subject_alternative_names = [format("%s.%s", "${region_dashed}", var.apigateway_domain_name)]
  hosted_zone_id            = var.hosted_zone_id

  providers = {
    aws = aws.${region_underscored}
  }
}

module "apigateway_${region_underscored}" {
  source = "../../modules/apigateway"

  name                = var.apigateway_name
  domain_name         = var.apigateway_domain_name
  hosted_zone_id      = var.hosted_zone_id
  acm_certificate_arn = module.apigateway_certificate_${region_underscored}.cert_arn

  function_name = module.lambda_${region_underscored}.function_name
  invoke_arn    = module.lambda_${region_underscored}.invoke_arn

  routes = var.apigateway_routes

  providers = {
    aws = aws.${region_underscored}
  }
}
