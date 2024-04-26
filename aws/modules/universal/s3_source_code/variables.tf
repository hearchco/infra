// this will get appended to region name
variable "bucket_name" {
  type = string
}

variable "path" {
  type    = string
  default = "tmp"
}

variable "filename" {
  type = string

  validation {
    condition     = var.filename == "bootstrap" || var.filename == "index.mjs"
    error_message = "Only 'bootstrap' or 'index.mjs' are allowed"
  }
}
