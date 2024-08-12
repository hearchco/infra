variable "aws_profile" {
  description = "The AWS profile to use for the aliased global provider"
  type        = string
}

variable "domain_name" {
  description = "The domain name to create the Hosted Zone for"
  type        = string
}

variable "records" {
  description = "A list of DNS records to create in the Route53 zone"
  type = set(object({
    name    = string
    type    = string
    ttl     = optional(number, 86400)
    records = set(string)
  }))
  default = []
}

variable "dnssec" {
  description = "Whether to enable DNSSEC for the Route53 zone"
  type        = bool
  default     = false
}
