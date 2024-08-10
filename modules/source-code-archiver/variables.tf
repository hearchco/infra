variable "source_code" {
  description = "Source of the file to archive, either read from provided filepath or using content"
  type = object({
    filepath         = optional(string)
    content          = optional(string)
    content_filename = optional(string)
  })

  validation {
    condition = (
      (var.source_code.filepath != null && var.source_code.content == null && var.source_code.content_filename == null) ||
      (var.source_code.filepath == null && var.source_code.content != null && var.source_code.content_filename != null)
    )
    error_message = "Either filepath or content must be provided"
  }
}

variable "output_filepath" {
  description = "The path to save the archive file to"
  type        = string
  default     = "archive.zip"
}
