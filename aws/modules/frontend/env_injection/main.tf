data "local_file" "source_file" {
  filename = "${var.path}/${var.source_file}"
}
