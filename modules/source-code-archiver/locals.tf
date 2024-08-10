locals {
  # Ensure the output filepath ends with ".zip"
  output_filepath = var.output_filepath != null && var.output_filepath != "" ? can(regex(".*\\.zip$", var.output_filepath)) ? var.output_filepath : "${var.output_filepath}.zip" : null

  # Extract the output filename ending with ".zip" from the output filepath, e.g. "path/to/file.zip" -> "file.zip" and "file.zip" -> "file.zip"
  output_filename = local.output_filepath != null ? regex("(?:[^/]+/)*(.+[.]zip)$", local.output_filepath)[0] : null
}
