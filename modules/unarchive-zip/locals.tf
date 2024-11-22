locals {
  filename_zipped   = endswith(var.filename, ".zip") ? var.filename : "${var.filename}.zip"
  filename_unzipped = endswith(var.filename, ".zip") ? substr(var.filename, 0, length(var.filename) - 4) : var.filename

  filepath     = "${path.module}/.terraform/${local.filename_zipped}"
  extract_path = "${path.module}/.terraform/${local.filename_unzipped}"

  extract_cmd = "unzip -o ${local_file.write.filename} -d \"${local.extract_path}\""
}
