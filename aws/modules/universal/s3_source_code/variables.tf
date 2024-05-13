// this will get appended to region name
variable "bucket_name" {
  type = string
}

variable "bucket_name_suffix" {
  type      = string
  default   = ""
  sensitive = true
}

variable "archive_path" {
  type = string
}

variable "archive_base64sha256" {
  type = string
}

variable "filename" {
  type = string

  validation {
    condition     = var.filename == "bootstrap" || var.filename == "index.mjs"
    error_message = "Only 'bootstrap' or 'index.mjs' are allowed"
  }
}
