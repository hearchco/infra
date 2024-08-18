variable "domain_name" {
  description = "The domain name for which the certificate should be issued"
  type        = string
}

variable "subject_alternative_names" {
  description = "A list of additional domain names to be included in the Subject Alternative Name extension of the ACM certificate"
  type        = set(string)
  default     = []
}

variable "hosted_zone_id" {
  description = "The Route 53 hosted zone ID that the domain name and subject alternative names are managed in"
  type        = string
}

variable "key_algorithm" {
  description = "The algorithm that will be used to generate the key pair of the certificate"
  type        = string
  default     = "EC_prime256v1"
}
