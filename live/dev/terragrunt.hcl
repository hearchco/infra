locals {
  environment = "dev"
  aws_profile = "891377085136_Admin"
  domain_name = local.environment == "prod" ? "hearch.co" : "${local.environment}.hearch.co"
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "hearchco-shared-${local.environment}-tf-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    profile        = local.aws_profile
    dynamodb_table = "hearchco-shared-${local.environment}-tf-state-lock"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  profile = "${local.aws_profile}"
  region  = "eu-central-1"
}
EOF
}
