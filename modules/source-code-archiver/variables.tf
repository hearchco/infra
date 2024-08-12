variable "source_code" {
  description = "Source of the file to archive, either read from provided filepath or using content"
  type = object({
    source_dir       = optional(string)
    source_file      = optional(string)
    content          = optional(string)
    content_filename = optional(string)
  })

  validation {
    condition = (
      (var.source_code.source_dir != null && var.source_code.source_file == null && var.source_code.content == null && var.source_code.content_filename == null) ||
      (var.source_code.source_dir == null && var.source_code.source_file != null && var.source_code.content == null && var.source_code.content_filename == null) ||
      (var.source_code.source_dir == null && var.source_code.source_file == null && var.source_code.content != null && var.source_code.content_filename != null)
    )
    error_message = "Only one of source_dir, source_file or content (with content_filename) must be provided"
  }
}

variable "output_filepath" {
  description = "The path to save the archive file to"
  type        = string
  default     = "archive.zip"
}
