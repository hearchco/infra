variable "filepath" {
  description = "The file path to inject environment variables into"
  type        = string
}

variable "placeholder" {
  description = "The placeholder to replace with the environment variables"
  type        = string
  default     = "'{{_EDGE_FUNCTION_ENVIRONMENT_}}'"
}

variable "environment" {
  description = "The environment variables to inject"
  type        = map(string)
  default     = {}
}
