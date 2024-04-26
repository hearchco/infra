terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/dev/frontend/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

# us-east-1 region required for Cloudfront's certificate and Lambda@Edge
provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
  alias   = "us-east-1-cdn"
}

# Route53 DNS
data "aws_route53_zone" "hearchco_route53" {
  name = var.domain_name
}
