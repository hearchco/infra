variable "aws_profile" {
  description = "AWS profile to use for CloudFront provider"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone for the domain name"
  type        = string
}

variable "release_tag" {
  description = "The release tag to download & deploy"
  type        = string
}

variable "release_repository" {
  description = "The repository to download the release from"
  type        = string
  default     = "frontend"
}

variable "release_repository_owner" {
  description = "The owner of the repository to download the release from"
  type        = string
  default     = "hearchco"
}

##### Cloudfront variables #####
variable "cloudfront_name" {
  description = "The name of the CloudFront distribution"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "The domain name for the CloudFront distribution"
  type        = string
}

variable "cloudfront_price_class" {
  description = "The price class for the CloudFront distribution"
  type        = string
}

variable "cloudfront_default_cache_behavior" {
  description = "The default cache behavior of the CloudFront distribution"
  type = object({
    allowed_methods = optional(set(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods  = optional(set(string), ["GET", "HEAD"])

    cache_policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })
  })
}

variable "cloudfront_s3_static_cache_behavior" {
  description = "The cache behavior for the S3 static assets"
  type = object({
    allowed_methods = optional(set(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods  = optional(set(string), ["GET", "HEAD"])

    cache_policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })
  })
}

variable "cloudfront_ordered_cache_behaviors" {
  description = "The ordered cache behaviors of the CloudFront distribution"
  type = set(object({
    path_pattern    = string
    allowed_methods = optional(set(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods  = optional(set(string), ["GET", "HEAD"])

    cache_policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })
  }))
}

##### API Gateway variables #####
variable "apigateway_name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "apigateway_domain_name" {
  description = "The domain name for the API Gateway"
  type        = string
}

variable "apigateway_routes" {
  description = "The routes for the API Gateway"
  type        = set(string)
}

##### Lambda variables #####
variable "lambda_src_bucket_name" {
  description = "The name of the bucket to upload the source code to"
  type        = string
}

variable "lambda_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "lambda_runtime" {
  description = "The runtime to use for the Lambda function"
  type        = string
  default     = "nodejs20.x"
}

variable "lambda_handler" {
  description = "The handler to use for the Lambda function"
  type        = string
  default     = "index.handler"
}

variable "lambda_memory_size" {
  description = "The amount of memory to allocate to the Lambda function"
  type        = number
  default     = 1769 # 2vCPUs with max 1 core 100% utilization
}

variable "lambda_architecture" {
  description = "The architecture to use for the Lambda function"
  type        = string
  default     = "arm64"
}

variable "lambda_agent_api_gateway_domain_name" {
  description = "The domain name for the API Gateway of Agent API"
  type        = string
}

variable "lambda_agent_cloudfront_domain_name" {
  description = "The domain name for the CloudFront distribution of Agent API"
  type        = string
}

variable "lambda_environment" {
  description = "The environment to pass to the Lambda function"
  type        = map(string)
  sensitive   = true
}

variable "lambda_keep_warm" {
  description = "Whether to keep the Lambda function warm"
  type        = bool
  default     = false
}

##### S3 variables #####
variable "s3_bucket_name" {
  description = "The name of the S3 bucket for the static assets"
  type        = string
}

variable "s3_static_assets_path" {
  description = "The path to the folder containing the static assets"
  type        = string
}
