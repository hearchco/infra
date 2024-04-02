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
  profile = local.profile
  region  = "eu-central-1"
}

# Global modules

## Route53 DNS
module "hearchco_route53" {
  source      = "../../modules/backend/route53"
  domain_name = "dev.api.hearch.co"
}

## Lambda
### Random string for proxy salt
module "salt" {
  source = "../../modules/backend/random"
}

### IAM for lambda execution and logging
module "lambda_iam" {
  source = "../../modules/backend/lambda_iam"
}

## Cloudfront
### us-east-1 region required for Cloudfront's certificate
provider "aws" {
  profile = local.profile
  region  = "us-east-1"
  alias   = "us-east-1-cdn"
}

### Certificate for the Cloudfront distribution
module "hearchco_cdn_certificate" {
  source         = "../../modules/backend/acm"
  domain_name    = local.cdn_domain_name
  hosted_zone_id = module.hearchco_route53.hosted_zone_id

  providers = {
    aws = aws.us-east-1-cdn
  }
}

### Cloudfront distribution for all API Gateways (in all regions)
module "hearchco_cloudfront" {
  source              = "../../modules/backend/cloudfront"
  domain_name         = local.cdn_domain_name
  hosted_zone_id      = module.hearchco_route53.hosted_zone_id
  target_domain_name  = module.hearchco_apigateway_eu_central_1.target_domain_name
  acm_certificate_arn = module.hearchco_cdn_certificate.cert_arn

  paths = {
    "/search" = {
      min_ttl     = 0
      default_ttl = 86400  // 1 day
      max_ttl     = 259200 // 3 days
    },
    "/proxy" = {
      min_ttl     = 0
      default_ttl = 1296000 // 15 days
      max_ttl     = 2592000 // 30 days
    },
  }

  providers = {
    aws = aws.us-east-1-cdn
  }
}
