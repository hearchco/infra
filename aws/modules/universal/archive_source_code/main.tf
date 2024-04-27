data "archive_file" "source_code" {
  type                    = "zip"
  source_file             = var.content == null ? "${var.path}/${var.filename}" : null
  source_content          = var.content
  source_content_filename = var.content != null ? var.filename : null
  output_path             = "${var.path}/${var.filename}.zip"
}
