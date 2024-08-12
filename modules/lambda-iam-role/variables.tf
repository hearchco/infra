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

variable "dynamodb_policy" {
  description = "Whether to attach a DynamoDB policy to the role"
  type        = bool
  default     = false
}

variable "dynamodb_policy_arn" {
  description = "ARN of the DynamoDB policy to attach to the role"
  type        = string
  default     = null
}
