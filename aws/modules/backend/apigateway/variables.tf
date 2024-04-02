variable "integration_type" {
  type    = string
  default = "AWS_PROXY"
}

variable "integration_method" {
  type    = string
  default = "POST"
}

variable "payload_format_version" {
  type    = string
  default = "2.0"
}

variable "connection_type" {
  type    = string
  default = "INTERNET"
}

variable "function_name" {
  type = string
}

variable "invoke_arn" {
  type = string
}

variable "stage_name" {
  type    = string
  default = "$default"
}

variable "auto_deploy" {
  type    = bool
  default = true
}

variable "domain_name" {
  type = string
}

variable "hosted_zone_id" {
  type = string
}

variable "acm_certificate_arn" {
  type = string
}

variable "routes" {
  type = set(string)
}
