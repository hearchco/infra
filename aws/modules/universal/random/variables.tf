variable "min_chars" {
  type    = number
  default = 48
}

variable "max_chars" {
  type    = number
  default = 64
}

variable "upper" {
  type    = bool
  default = true
}

variable "lower" {
  type    = bool
  default = true
}

variable "numeric" {
  type    = bool
  default = true
}

variable "special" {
  type    = bool
  default = false
}
