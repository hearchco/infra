variable "name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "Controls how you are charged for read and write throughput and how you manage capacity"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "lambda_iam_role" {
  description = "Whether to create an IAM policy for Lambda to access the DynamoDB table"
  type        = bool
  default     = true
}

variable "read_capacity" {
  description = "The number of read units for this table"
  type        = number
  default     = null
}

variable "write_capacity" {
  description = "The number of write units for this table"
  type        = number
  default     = null
}

# variable "read_capacity_autoscaling" {
#   description = "The autoscaling configuration for read capacity units"
#   type = object({
#     enabled          = bool
#     min_capacity     = optional(number, 5)
#     max_capacity     = optional(number, 25)
#     usage_percentage = optional(number, 70.0)
#   })
#   nullable = false
#   default = {
#     enabled = false
#   }
# }

# variable "write_capacity_autoscaling" {
#   description = "The autoscaling configuration for write capacity units"
#   type = object({
#     enabled          = bool
#     min_capacity     = optional(number, 5)
#     max_capacity     = optional(number, 25)
#     usage_percentage = optional(number, 70.0)
#   })
#   nullable = false
#   default = {
#     enabled = false
#   }
# }

variable "attributes" {
  description = "A list of attributes for the DynamoDB table"
  type = set(object({
    name      = string
    type      = string
    hash_key  = optional(bool, false)
    range_key = optional(bool, false)
  }))
  nullable = false

  validation {
    condition     = length(var.attributes) > 0
    error_message = "At least one attribute must be defined"
  }

  validation {
    condition     = length([for a in var.attributes : a if a.hash_key]) == 1
    error_message = "Exactly one attribute must be defined as a hash key"
  }

  validation {
    condition     = length([for a in var.attributes : a if a.range_key]) <= 1
    error_message = "At most one attribute must be defined as a range key"
  }
}

variable "replicas" {
  description = "A list of replicas for creating a global DynamoDB table (just the region names)"
  type        = set(string)
  nullable    = false
  default     = []
}

variable "ttl" {
  description = "The TTL configuration for the DynamoDB table"
  type = object({
    enabled        = bool
    attribute_name = optional(string, "TTL")
  })
  nullable = false
  default = {
    enabled = false
  }
}

variable "global_secondary_indexes" {
  description = "A list of global secondary indexes for the DynamoDB table"
  type = set(object({
    name               = string
    range_key          = optional(string)
    write_capacity     = optional(number)
    read_capacity      = optional(number)
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  nullable = false
  default  = []
}

variable "local_secondary_indexes" {
  description = "A list of local secondary indexes for the DynamoDB table"
  type = set(object({
    name               = string
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  nullable = false
  default  = []
}
