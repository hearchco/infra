output "filename" {
  value = local.output_filename
}

output "output_path" {
  value = data.archive_file.source_code.output_path
}

output "output_base64sha256" {
  value = data.archive_file.source_code.output_base64sha256
}
