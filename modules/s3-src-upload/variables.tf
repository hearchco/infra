variable "bucket_name" {
  description = "The name of the bucket to upload the source code to, the region and account ID will be appended to this name"
  type        = string
}

variable "bucket_name_suffix" {
  description = "Used to obfuscate the bucket name"
  type        = string
  default     = ""
  sensitive   = true
}

variable "filename" {
  description = "The name of the file when uploaded, e.g. 'bootstrap.zip' or 'index.mjs.zip'"
  type        = string

  validation {
    condition     = can(regex(".*\\.zip$", var.filename))
    error_message = "The filename must end with '.zip'"
  }
}

variable "content_base64" {
  description = "The base64-encoded content of the source code archive file"
  type        = string
}

variable "content_base64sha256" {
  description = "The base64-encoded SHA256 hash of the source code archive file"
  type        = string
}
