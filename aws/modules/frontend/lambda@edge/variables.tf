variable "function_name" {
  type    = string
  default = "hearchco-ssr-lambda"
}

# has to correspond to file.function format in the source code
variable "handler" {
  type    = string
  default = "index.handler"
}

variable "runtime" {
  type    = string
  default = "nodejs20.x"
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

// since Lambda@Edge doesn't support enviroment variables, it's required to pass them as a part of the function
# variable "environment" {
#   type    = map(string)
#   default = {}
# }

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
