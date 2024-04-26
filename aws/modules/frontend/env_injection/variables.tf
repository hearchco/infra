variable "source_file" {
  type    = string
  default = "tmp/lambda/index.mjs"
}

variable "placeholder" {
  type    = string
  default = "'{{_EDGE_FUNCTION_ENVIRONMENT_}}'"
}

variable "environment" {
  type    = map(string)
  default = {}
}
