locals {
  additional_records_map = { for record in var.additional_records : base64sha256(
    "${record.name}-${record.type}"
  ) => record }
}
