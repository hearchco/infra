variable "name" {
  description = "The name of the CloudFront distribution, used for naming resources"
  type        = string
}

variable "hosted_zone_id" {
  description = "The hosted zone ID of the wanted domain"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the CloudFront distribution"
  type        = string
}

variable "price_class" {
  description = "The price class of the CloudFront distribution"
  type        = string
}

variable "origins" {
  description = "The origins of the CloudFront distribution"
  type = list(object({
    origin_id   = string
    origin_type = string
    domain_name = string
    s3_oai_id   = optional(string)
  }))

  validation {
    condition     = length(var.origins) > 0
    error_message = "At least one origin must be provided"
  }

  validation {
    condition     = length([for origin in var.origins : origin.origin_id]) == length(distinct([for origin in var.origins : origin.origin_id]))
    error_message = "Origin IDs must be unique"
  }

  validation {
    condition     = alltrue([for origin in var.origins : contains(["s3", "custom"], origin.origin_type)])
    error_message = "Origin type must be either 's3' or 'custom'"
  }

  validation {
    condition     = alltrue([for origin in var.origins : origin.origin_type == "s3" ? (origin.s3_oai_id != null && origin.s3_oai_id != "") : true])
    error_message = "S3 origins must have 's3_oai_id' attribute"
  }
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

variable "origin_header_behavior" {
  description = "The header behavior for the CloudFront distribution origin requests"
  type        = string
  default     = "whitelist"
}

variable "origin_header_items" {
  description = "The header items for the CloudFront distribution origin requests"
  type        = set(string)
  default = [
    "Accept",
    "Accept-Language",
    "Access-Control-Request-Headers",
    "Access-Control-Request-Method",
    "Origin",
    "X-Forwarded-Host",
  ]
}

variable "cache_header_behavior" {
  description = "The header behavior for the CloudFront distribution cache requests"
  type        = string
  default     = "whitelist"
}

variable "cache_header_items" {
  description = "The header items for the CloudFront distribution cache requests"
  type        = set(string)
  default = [
    "Accept",
    "Accept-Language",
    "Access-Control-Request-Headers",
    "Access-Control-Request-Method",
    "Origin",
  ]
}

variable "default_allowed_methods" {
  description = "The default allowed methods for the CloudFront distribution"
  type        = set(string)
  default     = ["HEAD", "GET", "OPTIONS"]
}

variable "default_cached_methods" {
  description = "The default cached methods for the CloudFront distribution"
  type        = set(string)
  default     = ["HEAD", "GET"]
}

variable "default_viewer_protocol_policy" {
  description = "The default viewer protocol policy for the CloudFront distribution"
  type        = string
  default     = "redirect-to-https"
}

variable "default_cache" {
  description = "The default cache configuration pointing to the first origin of the CloudFront distribution"
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
}

variable "ordered_cache_behaviors" {
  description = "The ordered cache behaviors for the CloudFront distribution"
  type = set(object({
    path_pattern           = string
    allowed_methods        = optional(set(string), ["HEAD", "GET", "OPTIONS"])
    cached_methods         = optional(set(string), ["HEAD", "GET"])
    target_origin_id       = string
    viewer_protocol_policy = optional(string, "redirect-to-https")

    function_associations = optional(set(object({
      event_type    = string
      function_name = string
    })), [])

    lambda_function_associations = optional(set(object({
      lambda_arn   = string
      event_type   = string
      include_body = optional(bool, true)
    })), [])

    policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })
  }))
}
