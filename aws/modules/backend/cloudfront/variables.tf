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

variable "paths" {
  type = map(object({
    min_ttl     = number
    default_ttl = number
    max_ttl     = number
  }))
  default = {}
}

variable "allowed_methods" {
  type    = set(string)
  default = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
}

variable "cached_methods" {
  type    = set(string)
  default = ["HEAD", "GET"]
}
