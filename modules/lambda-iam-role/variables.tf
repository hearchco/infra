variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "policy_name" {
  description = "Name of the IAM policy"
  type        = string
}

variable "identifiers" {
  description = "List of identifiers to attach to the role"
  type        = set(string)
  default     = []
}

variable "edge" {
  description = "Whether to create a role for edge lambdas"
  type        = bool
  default     = false
}
