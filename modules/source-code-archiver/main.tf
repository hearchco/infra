data "archive_file" "source_code" {
  type                    = "zip"
  source_dir              = var.source_code.source_dir
  source_file             = var.source_code.source_file
  source_content          = var.source_code.content
  source_content_filename = var.source_code.content_filename
  output_path             = local.output_filepath
}
