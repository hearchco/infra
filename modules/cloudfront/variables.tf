variable "name" {
  description = "The name of the CloudFront distribution"
  type        = string
}

variable "domain_name" {
  description = "The domain name of the CloudFront distribution"
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

variable "origin_request_header_behavior" {
  description = "The header behavior for the CloudFront distribution origin requests"
  type        = string
  default     = "whitelist"
}

variable "origin_request_header_items" {
  description = "The header items for the CloudFront distribution origin requests"
  type        = set(string)
  default = [
    "Accept",
    "Accept-Language",
    "Access-Control-Request-Headers",
    "Access-Control-Request-Method",
    "Origin",
  ]
}

variable "additional_origin_request_header_items" {
  description = "The header items for the CloudFront distribution origin requests"
  type        = set(string)
  default     = []
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

variable "additional_cache_header_items" {
  description = "Additional header items for the CloudFront distribution cache requests"
  type        = set(string)
  default     = []
}

variable "default_cache_behavior" {
  description = "The default cache behavior of the CloudFront distribution"
  type = object({
    allowed_methods        = optional(set(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods         = optional(set(string), ["GET", "HEAD"])
    target_origin_id       = string
    viewer_protocol_policy = optional(string, "redirect-to-https")

    cache_policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })

    function_associations = optional(set(object({
      name          = string
      src_file_path = string
      event_type    = optional(string, "viewer-request")
    })), [])

    lambda_function_associations = optional(set(object({
      lambda_arn   = string
      event_type   = optional(string, "origin-request")
      include_body = optional(bool, true)
    })), [])
  })
}

variable "ordered_cache_behaviors" {
  description = "The ordered cache behaviors of the CloudFront distribution"
  type = set(object({
    path_pattern           = string
    allowed_methods        = optional(set(string), ["GET", "HEAD", "OPTIONS"])
    cached_methods         = optional(set(string), ["GET", "HEAD"])
    target_origin_id       = string
    viewer_protocol_policy = optional(string, "redirect-to-https")

    cache_policy = object({
      min_ttl     = number
      default_ttl = number
      max_ttl     = number
    })

    function_associations = optional(set(object({
      name          = string
      src_file_path = string
      event_type    = optional(string, "viewer-request")
    })), [])

    lambda_function_associations = optional(set(object({
      lambda_arn   = string
      event_type   = optional(string, "origin-request")
      include_body = optional(bool, true)
    })), [])
  }))
}
