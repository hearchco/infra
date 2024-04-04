terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/dev/dns/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

module "hearchco_route53" {
  source      = "../../modules/dns/route53"
  domain_name = var.domain_name
}
