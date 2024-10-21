variable "filename" {
  description = "The name of the zip file"
  type        = string
}

variable "content" {
  description = "The content of a zip file"
  type = object({
    content        = optional(string)
    content_base64 = optional(string)
  })

  validation {
    condition     = var.content.content != null || var.content.content_base64 != null
    error_message = "Either content or content_base64 must be provided"
  }

  validation {
    condition     = var.content.content == null || var.content.content_base64 == null
    error_message = "Only one of content or content_base64 must be provided"
  }
}
