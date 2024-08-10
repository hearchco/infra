variable "name" {
  description = "The name of the CloudFront distribution, used for naming resources"
  type        = string
}

variable "origin_type" {
  description = "The type of the origin, either S3 bucket or custom origin"
  type        = string

  validation {
    condition     = contains(["s3", "custom"], var.origin_type)
    error_message = "Origin type must be either 's3' or 'custom'"
  }
}

variable "domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = string
}

variable "target_domain_name" {
  description = "The domain name of the target origin"
  type        = string
}

variable "price_class" {
  description = "The price class of the CloudFront distribution"
  type        = string
}

variable "hosted_zone_id" {
  description = "The hosted zone ID of the wanted domain"
  type        = string
}

variable "s3_static_oai_id" {
  description = "The OAI ID of the S3 static bucket"
  type        = string
  default     = null
}

variable "cf_functions" {
  description = "The Cloudfront v2 functions to associate with the CloudFront distribution"
  type = set(object({
    name          = string
    src_file_path = string
    event_type    = optional(string, "viewer-request")
  }))
  default = []
}

variable "lambda_functions" {
  description = "The Lambda@Edge functions to associate with the CloudFront distribution"
  type = set(object({
    arn          = string
    event_type   = optional(string, "origin-request")
    include_body = optional(bool, true)
  }))
  default = []
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "allowed_methods" {
  description = "The allowed methods for the CloudFront distribution"
  type        = set(string)
  default     = ["HEAD", "GET", "OPTIONS", "POST", "PUT", "PATCH", "DELETE"]
}

variable "cached_methods" {
  description = "The cached methods for the CloudFront distribution"
  type        = set(string)
  default     = ["HEAD", "GET"]
}

variable "s3_static_allowed_methods" {
  description = "The allowed methods for the S3 static bucket"
  type        = set(string)
  default     = ["HEAD", "GET", "OPTIONS"]
}

variable "s3_static_cached_methods" {
  description = "The cached methods for the S3 static bucket"
  type        = set(string)
  default     = ["HEAD", "GET"]
}

variable "header_behavior" {
  description = "The header behavior for the CloudFront distribution"
  type        = string
  default     = "whitelist"
}

variable "header_items" {
  description = "The header items for the CloudFront distribution"
  type        = set(string)
  default = [
    "Accept",
    "Accept-Language",
    "Access-Control-Request-Headers",
    "Access-Control-Request-Method",
    "Origin",
    // "X-Forwarded-Host",
  ]
}

variable "default_cache" {
  description = "The default cache configuration for the CloudFront distribution"
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
}

variable "custom_paths_cache" {
  type = map(object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  }))
  default = {}
}

variable "s3_static_default_cache" {
  description = "The default cache configuration for the S3 static bucket"
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
  default = null
}

variable "s3_static_top_level_assets" {
  description = "The top level assets for the S3 static bucket"
  type        = set(string)
  default     = []
}
