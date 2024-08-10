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
