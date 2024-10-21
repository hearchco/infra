resource "local_file" "write" {
  content        = var.content.content
  content_base64 = var.content.content_base64
  filename       = local.filepath
}

resource "terraform_data" "unarchive" {
  input = local.extract_path
  triggers_replace = [
    local.extract_cmd,
    timestamp() # Force re-run on every apply
  ]

  provisioner "local-exec" {
    command = local.extract_cmd
  }

  depends_on = [local_file.write]
}
