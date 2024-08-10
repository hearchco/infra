data "archive_file" "source_code" {
  type                    = "zip"
  source_file             = var.source_code.filepath
  source_content          = var.source_code.content
  source_content_filename = var.source_code.content_filename
  output_path             = local.output_filepath
}
