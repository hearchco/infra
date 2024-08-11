variable "aws_profile" {
  description = "AWS profile to use for CloudFront provider"
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone for the domain name"
  type        = string
}

###### Cloudfront variables #####
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
variable "lambda_src_filepath" {
  description = "The path to the source code file"
  type        = string
}

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
  default     = "provided.al2"
}

variable "lambda_handler" {
  description = "The handler to use for the Lambda function"
  type        = string
  default     = "bootstrap.zip"
}

variable "lambda_memory_size" {
  description = "The amount of memory to allocate to the Lambda function"
  type        = number
  default     = 3008
}

variable "lambda_architecture" {
  description = "The architecture to use for the Lambda function"
  type        = string
  default     = "x86_64"
}

variable "lambda_environment" {
  description = "The environment to pass to the Lambda function"
  type        = map(string)
  sensitive   = true
}
