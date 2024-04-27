output "filename" {
  value = var.source_file
}

output "content" {
  value = replace(
    data.local_file.source_file.content,
    var.placeholder,
    jsonencode(var.environment)
  )
}
