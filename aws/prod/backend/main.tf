terraform {
  backend "s3" {
    profile        = "992382822186_TFStateLock"
    region         = "eu-central-1"
    dynamodb_table = "hearchco-shared-tf-state"
    bucket         = "hearchco-shared-tf-state"
    key            = "aws/prod/backend/terraform.tfstate"
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
  source = "../../modules/universal/random"
}

### Random suffix for S3 source code name
module "s3_source_code_suffix" {
  source = "../../modules/universal/random"

  min_chars = 6
  max_chars = 10
  upper     = false
  special   = false
}

### IAM for lambda execution and logging
module "lambda_iam" {
  source = "../../modules/universal/lambda_iam"

  role_name   = "aws-iam-role-exec-hearchco-api"
  policy_name = "hearchco_api_logging"
}

### Archived source code for Lambda
module "hearchco_archiver" {
  source   = "../../modules/universal/archive_source_code"
  filename = "bootstrap"
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
  price_class         = "PriceClass_All"

  paths_cache = {
    "/search" = {
      min_ttl     = 3600   // 1 hour
      default_ttl = 86400  // 1 day
      max_ttl     = 259200 // 3 days
    },
    "/suggestions" = {
      min_ttl     = 3600   // 1 hour
      default_ttl = 86400  // 1 day
      max_ttl     = 259200 // 3 days
    },
    "/proxy" = {
      min_ttl     = 86400   // 1 day
      default_ttl = 1296000 // 15 days
      max_ttl     = 2592000 // 30 days
    },
    "/healthz" = {
      min_ttl     = 5 // 5 seconds
      default_ttl = 5 // 5 seconds
      max_ttl     = 5 // 5 seconds
    },
    "/versionz" = {
      min_ttl     = 60 // 1 minute
      default_ttl = 180 // 3 minutes
      max_ttl     = 3600 // 1 hour
    },
  }

  providers = {
    aws = aws.us-east-1-cdn
  }
}
