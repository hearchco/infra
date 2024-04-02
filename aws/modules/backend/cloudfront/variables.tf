variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "target_domain_name" {
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

variable "paths_cache" {
  type = map(object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  }))
  default = {}
}
