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
