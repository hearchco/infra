locals {
  binary_name = "bootstrap"
  source_file = "${var.path}/${local.binary_name}"
  output_path = "${local.source_file}.zip"

  // create a map of bucket names to their index in the list
  buckets_to_replicate_index = { for idx, name in keys(var.buckets_to_replicate) : name => idx }
}
