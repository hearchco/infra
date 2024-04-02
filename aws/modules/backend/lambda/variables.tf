variable "function_name" {
  type    = string
  default = "hearchco-lambda"
}

# Has to be named this for Go runtime to work on Amazon Linux 2 custom runtime
variable "handler" {
  type    = string
  default = "bootstrap"
}

variable "runtime" {
  type    = string
  default = "provided.al2"
}

variable "role" {
  type = string
}

variable "s3_bucket" {
  type = string
}

variable "s3_key" {
  type = string
}

variable "source_code_hash" {
  type = string
}

# If null it will be automatically generated (48-64 characters without special characters)
variable "proxy_salt" {
  type      = string
  sensitive = true
}

variable "environment" {
  type    = map(string)
  default = {}
}

# environment=lambda and salt
variable "use_default_env" {
  type    = bool
  default = true
}

variable "architectures" {
  type    = list(string)
  default = ["arm64"]
}

variable "memory_size" {
  type    = number
  default = 128
}

variable "timeout" {
  type    = number
  default = 5
}
