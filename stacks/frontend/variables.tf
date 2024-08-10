variable "hosted_zone_id" {
  description = "The ID of the hosted zone for the domain name"
  type        = string
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

variable "cloudfront_cf_function_path" {
  description = "The path to the CloudFront function source code"
  type        = string
}

variable "cloudfront_default_cache" {
  description = "The default cache configuration for the CloudFront distribution"
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
}

variable "cloudfront_custom_paths_cache" {
  type = map(object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  }))
}

variable "cloudfront_s3_static_default_cache" {
  description = "The default cache configuration for the S3 static bucket"
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
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
  default     = "nodejs20.x"
}

variable "lambda_handler" {
  description = "The handler to use for the Lambda function"
  type        = string
  default     = "index.handler"
}

variable "lambda_environment" {
  description = "The environment to pass to the Lambda function"
  type        = map(string)
  sensitive   = true
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
