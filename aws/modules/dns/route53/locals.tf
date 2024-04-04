locals {
  additional_records_map = { for idx, record in tolist(var.additional_records) : idx => record }
}
