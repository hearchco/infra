terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/dev/backend/terraform.tfstate"
    encrypt        = "true"
  }
}

provider "aws" {
  profile = var.aws_profile
  region  = "eu-central-1"
}

# Global modules

## Route53 DNS
data "aws_route53_zone" "hearchco_route53" {
  name = var.domain_name
}

## Lambda
### Random string for proxy salt
module "salt" {
  source = "../../modules/backend/random"
}

### IAM for lambda execution and logging
module "lambda_iam" {
  source = "../../modules/universal/lambda_iam"

  role_name   = "aws-iam-role-exec-hearchco-api"
  policy_name = "hearchco_api_logging"
}

## Cloudfront
### us-east-1 region required for Cloudfront's certificate
provider "aws" {
  profile = var.aws_profile
  region  = "us-east-1"
  alias   = "us-east-1-cdn"
}

### Certificate for the Cloudfront distribution
module "hearchco_cdn_certificate" {
  source         = "../../modules/universal/acm"
  domain_name    = local.api_domain_name
  hosted_zone_id = data.aws_route53_zone.hearchco_route53.zone_id

  providers = {
    aws = aws.us-east-1-cdn
  }
}

### Cloudfront distribution for all API Gateways (in all regions)
module "hearchco_cloudfront" {
  source              = "../../modules/backend/cloudfront"
  domain_name         = local.api_domain_name
  hosted_zone_id      = data.aws_route53_zone.hearchco_route53.zone_id
  target_domain_name  = module.hearchco_apigateway_eu_central_1.target_domain_name
  acm_certificate_arn = module.hearchco_cdn_certificate.cert_arn
  price_class         = "PriceClass_100"

  paths_cache = {
    "/search" = {
      min_ttl     = 0
      default_ttl = 0
      max_ttl     = 1
    },
    "/proxy" = {
      min_ttl     = 5
      default_ttl = 30
      max_ttl     = 60
    },
  }

  providers = {
    aws = aws.us-east-1-cdn
  }
}
