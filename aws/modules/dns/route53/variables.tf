variable "domain_name" {
  type = string
}

variable "records_caa" {
  type = set(string)
  default = [
    "0 issue \"letsencrypt.org\"",
    "0 issue \"amazon.com\"",
    "0 issue \"amazontrust.com\"",
    "0 issue \"awstrust.com\"",
    "0 issue \"amazonaws.com\"",
  ]
}

variable "additional_records" {
  type = set(object({
    name    = string
    type    = string
    ttl     = optional(number, 86400)
    records = set(string)
  }))
  default = []
}
