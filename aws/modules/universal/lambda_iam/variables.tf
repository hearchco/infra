variable "role_name" {
  type = string
}

variable "policy_name" {
  type = string
}

variable "identifiers" {
  type    = set(string)
  default = []
}

variable "edge" {
  type    = bool
  default = false
}
