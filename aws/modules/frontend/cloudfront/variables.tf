variable "domain_name" {
  type = string
}

variable "target_domain_name" {
  type = string
}

variable "oai_id" {
  type = string
}

variable "function_path" {
  type    = string
  default = "tmp/cloudfront/index.js"
}

variable "lambda_edge_arn" {
  type = string
}

variable "price_class" {
  type    = string
  default = "PriceClass_All"
}

variable "hosted_zone_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "allowed_methods" {
  type    = set(string)
  default = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
}

variable "cached_methods" {
  type    = set(string)
  default = ["HEAD", "GET"]
}

variable "allowed_methods_s3" {
  type    = set(string)
  default = ["HEAD", "GET", "OPTIONS"]
}

variable "cached_methods_s3" {
  type    = set(string)
  default = ["HEAD", "GET"]
}

variable "default_cache" {
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
  default = {
    min_ttl     = 60    // 1 minute
    default_ttl = 21600 // 6 hours
    max_ttl     = 86400 // 1 day
  }
}

variable "default_asset_cache" {
  type = object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  })
  default = {
    min_ttl     = 60    // 1 minute
    default_ttl = 21600 // 6 hours
    max_ttl     = 86400 // 1 day
  }
}

variable "top_level_assets" {
  type    = set(string)
  default = []
}

variable "paths_cache" {
  type = map(object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  }))
  default = {}
}
