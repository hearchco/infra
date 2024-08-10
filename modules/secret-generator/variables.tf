variable "min_chars" {
  description = "The minimum number of characters in the generated secret"
  type        = number
  default     = 48
}

variable "max_chars" {
  description = "The maximum number of characters in the generated secret"
  type        = number
  default     = 64
}

variable "upper" {
  description = "Whether to include uppercase letters in the generated secret"
  type        = bool
  default     = true
}

variable "lower" {
  description = "Whether to include lowercase letters in the generated secret"
  type        = bool
  default     = true
}

variable "numeric" {
  description = "Whether to include numbers in the generated secret"
  type        = bool
  default     = true
}

variable "special" {
  description = "Whether to include special characters in the generated secret"
  type        = bool
  default     = false
}
