data "local_file" "source_file" {
  filename = "${var.path}/${var.source_file}"
}

locals {
  environment_string        = jsonencode(var.environment)
  source_content            = data.local_file.source_file.content
  substitude_source_content = replace(local.source_content, var.placeholder, local.environment_string)
}

resource "local_file" "output_file" {
  content  = local.substitude_source_content
  filename = "${var.path}/injected/${var.source_file}"
}
