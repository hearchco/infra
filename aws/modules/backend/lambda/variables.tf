variable "function_name" {
  type    = string
  default = "hearchco-api-lambda"
}

# has to be named this for Go runtime to work on Amazon Linux 2 custom runtime
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

variable "proxy_salt" {
  type      = string
  sensitive = true
  validation {
    condition     = var.proxy_salt != ""
    error_message = "Proxy salt must be set"
  }
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
  default = 4
}
