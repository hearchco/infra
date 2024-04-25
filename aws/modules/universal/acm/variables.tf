variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "key_algorithm" {
  type    = string
  default = "EC_prime256v1"
}
