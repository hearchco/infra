module "image_proxy_secret_key" {
  source = "../../modules/secret-generator"

  min_chars = 44
  max_chars = 48
  special   = false
}

module "src_archiver" {
  source = "../../modules/source-code-archiver"

  source_code = {
    source_file = var.lambda_source_file
  }
  output_filepath = var.lambda_source_file
}

module "lambda_iam" {
  source = "../../modules/lambda-iam-role"

  role_name   = local.lambda_iam_role_name
  policy_name = local.lambda_iam_policy_name
}
