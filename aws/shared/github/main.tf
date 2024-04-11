terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/shared/github/terraform.tfstate"
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

module "github_shared_tf_state" {
  source = "../../modules/github/role"

  name       = "github-auth-shared-tf-state"
  repository = "hearchco/hearchco"

  statements = [
    {
      actions = [
        "s3:ListBucket"
      ]
      resources = ["arn:aws:s3:::hearchco-shared-tf-state"]
    },
    {
      actions = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ]
      resources = ["arn:aws:s3:::hearchco-shared-tf-state/*"]
    },
    {
      actions = [
        "dynamodb:DescribeTable",
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ]
      resources = ["arn:aws:dynamodb:*:*:table/hearchco-shared-tf-state"]
    }
  ]
}
