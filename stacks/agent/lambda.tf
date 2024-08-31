module "src_downloader" {
  source = "../../modules/github-asset-downloader"

  release_repository       = "agent"
  release_repository_owner = "hearchco"
  release_tag              = var.release_tag
  release_asset_name       = "hearchco_bootstrap_aws_${var.lambda_architecture == "arm64" ? "arm64" : "amd64"}.zip"
}

module "lambda_iam" {
  source = "../../modules/lambda-iam-role"

  role_name           = local.lambda_iam_role_name
  policy_name         = local.lambda_iam_policy_name
  dynamodb_policy     = true
  dynamodb_policy_arn = module.dynamodb_policy.lambda_access_policy_arn
}

module "image_proxy_secret_key" {
  source = "../../modules/secret-generator"

  min_chars = 44
  max_chars = 48
  special   = false
}
