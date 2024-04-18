variable "name" {
  type = string
}

variable "billing_mode" {
  type    = string
  default = "PROVISIONED"
}

variable "read_capacity" {
  type    = number
  default = 5
}

variable "write_capacity" {
  type    = number
  default = 5
}

variable "read_capacity_autoscaling" {
  type = object({
    enabled          = bool
    min_capacity     = optional(number, 5)
    max_capacity     = optional(number, 25)
    usage_percentage = optional(number, 70.0)
  })
  default = {
    enabled = false
  }
}

variable "write_capacity_autoscaling" {
  type = object({
    enabled          = bool
    min_capacity     = optional(number, 5)
    max_capacity     = optional(number, 25)
    usage_percentage = optional(number, 70.0)
  })
  default = {
    enabled = false
  }
}

variable "attributes" {
  type = set(object({
    name      = string
    type      = string
    hash_key  = optional(bool, false)
    range_key = optional(bool, false)
  }))
  default = []

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
  type    = set(string)
  default = []
}

variable "ttl" {
  type = object({
    enabled        = bool
    attribute_name = optional(string, "TimeToExist")
  })
  default = {
    enabled = false
  }
}

variable "global_secondary_indexes" {
  type = map(object({
    range_key          = optional(string)
    write_capacity     = optional(number)
    read_capacity      = optional(number)
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  default = {}
}

variable "local_secondary_indexes" {
  type = map(object({
    projection_type    = string
    non_key_attributes = optional(set(string))
  }))
  default = {}
}
