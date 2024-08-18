module "s3_bucket_name_suffix" {
  source = "../../modules/secret-generator"

  min_chars = 6
  max_chars = 8
  upper     = false
  special   = false
}

module "src_env_injection" {
  source = "../../modules/src-env-injection"

  filepath    = var.lambda_src_filepath
  environment = local.lambda_environment
}

module "src_archiver" {
  source = "../../modules/source-code-archiver"

  source_code = {
    content = module.src_env_injection.content
    # Extract the filename from var.lambda_src_filepath (e.g. "src/lambda/index.js" -> "index.js")
    content_filename = regex("^.*[/](.+)$", var.lambda_src_filepath)[0]
  }
  output_filepath = var.lambda_src_filepath
}

module "s3_src" {
  source = "../../modules/s3-src-upload"

  bucket_name          = var.lambda_src_bucket_name
  bucket_name_suffix   = module.s3_bucket_name_suffix.string
  filename             = module.src_archiver.filename
  archive_path         = module.src_archiver.output_path
  archive_base64sha256 = module.src_archiver.output_base64sha256

  providers = {
    aws = aws.edge
  }
}

module "lambda_iam" {
  source = "../../modules/lambda-iam-role"

  role_name   = local.lambda_iam_role_name
  policy_name = local.lambda_iam_policy_name
  edge        = true
}

module "lambda_edge" {
  source = "../../modules/lambda"

  name = var.lambda_name
  role = module.lambda_iam.role_arn

  runtime   = var.lambda_runtime
  handler   = var.lambda_handler
  keep_warm = false

  src_s3_bucket = module.s3_src.bucket_id
  src_s3_key    = module.s3_src.s3_key
  src_hash      = module.s3_src.source_code_hash

  edge = true

  providers = {
    aws = aws.edge
  }
}
