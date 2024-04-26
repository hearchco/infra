// last part of the path (divided by /)
output "filename" {
  value = split("/", local_file.output_file.filename)[length(split("/", local_file.output_file.filename)) - 1]
}

// everything except the last part of the path (divided by /)
output "path" {
  value = join("/", slice(split("/", local_file.output_file.filename), 0, length(split("/", local_file.output_file.filename)) - 1))
}
