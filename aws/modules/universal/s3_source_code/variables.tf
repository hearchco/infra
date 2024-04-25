// this will get appended to region name
variable "bucket_name" {
  type = string
}

variable "path" {
  type    = string
  default = "tmp"
}

variable "source_name" {
  type = string

  validation {
    condition     = var.source_name == "bootstrap" || var.source_name == "index.mjs"
    error_message = "Only 'bootstrap' or 'index.mjs' are allowed"
  }
}
