terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/dev/github/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

module "github_oidc" {
  source = "../../modules/github/oidc"
}

data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
}

module "github_backend_deploy" {
  source = "../../modules/github/role"

  name       = "github-auth-backend-deploy"
  repository = "hearchco/hearchco"

  statements = [
    {
      actions = [
        "s3:Get*",
        "s3:List*",
        "route53:Get*",
        "route53:List*",
        "apigateway:GET",
        "acm:List*",
        "acm:Describe*",
        "cloudfront:Get*",
        "cloudfront:List*",
        "lambda:Get*",
        "lambda:List*",
        "iam:Get*",
        "iam:List*"
      ]
      resources = ["*"]
    },
    {
      actions = [
        "s3:PutObject",
        "lambda:UpdateFunctionCode"
      ]
      resources = [
        "arn:aws:s3:::*/*",
        "arn:aws:lambda:*:*:function:*"
      ]
    }
  ]
}
