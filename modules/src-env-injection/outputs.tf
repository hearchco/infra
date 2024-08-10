output "content" {
  value = replace(
    data.local_file.original_file.content,
    var.placeholder,
    jsonencode(var.environment)
  )
}
