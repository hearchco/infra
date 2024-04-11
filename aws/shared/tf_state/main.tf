terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/shared/tf_state/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

locals {
  name = "hearchco-shared-tf-state"
}

module "tf_state" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.14.1"

  bucket = local.name
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled = true
  }
}

module "tf_lock" {
  source  = "terraform-aws-modules/dynamodb-table/aws"
  version = "3.3.0"

  name     = local.name
  hash_key = "LockID"
  attributes = [{
    name = "LockID"
    type = "S"
  }]
}
