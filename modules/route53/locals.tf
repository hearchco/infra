locals {
  records_map = { for record in var.records : "${record.type}-${record.name}" => record }
}
