variable "domain_name" {
  description = "The domain name to create Route53 zone and DNS records for"
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

variable "records_caa" {
  description = "A list of CAA DNS records to create in the Route53 zone"
  type        = set(string)
  default = [
    "0 issue \"letsencrypt.org\"",
    "0 issue \"amazon.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"awstrust.com\"",
    "0 issue \"amazonaws.com\"",
  ]
}

variable "dnssec" {
  description = "Whether to enable DNSSEC for the Route53 zone"
  type        = bool
  default     = false
}
