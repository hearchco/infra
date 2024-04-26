module "hearchco_env_injection" {
  source      = "../../modules/frontend/env_injection"
  environment = local.environment
}

module "hearchco_s3_source_code" {
  source      = "../../modules/universal/s3_source_code"
  bucket_name = "hearchco-ssr-function"
  filename    = module.hearchco_env_injection.filename
  path        = module.hearchco_env_injection.path

  depends_on = [module.hearchco_env_injection]

  providers = {
    aws = aws.us-east-1-cdn
  }
}

module "lambda_iam" {
  source = "../../modules/universal/lambda_iam"

  role_name   = "aws-iam-role-exec-hearchco-ssr"
  policy_name = "hearchco_ssr_logging"
  edge        = true
}

### Lambda@Edge for SSR (us-east-1 for Cloudfront)
module "hearchco_lambda_edge" {
  source           = "../../modules/frontend/lambda_edge"
  role             = module.lambda_iam.role_arn
  s3_bucket        = module.hearchco_s3_source_code.bucket_id
  s3_key           = module.hearchco_s3_source_code.s3_key
  source_code_hash = module.hearchco_s3_source_code.source_code_hash
  # environment      = local.environment # Not supported by Lambda@Edge

  depends_on = [module.hearchco_s3_source_code]

  providers = {
    aws = aws.us-east-1-cdn
  }
}
