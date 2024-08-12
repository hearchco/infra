resource "aws_dynamodb_table" "table" {
  name           = var.name
  billing_mode   = var.billing_mode
  read_capacity  = var.read_capacity
  write_capacity = var.write_capacity
  hash_key       = local.hash_key
  range_key      = local.range_key
  stream_enabled = length(var.replicas) > 0 ? true : false

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  dynamic "replica" {
    for_each = var.replicas
    content {
      region_name    = replica.key
      propagate_tags = true
    }
  }

  ttl {
    enabled        = var.ttl.enabled
    attribute_name = var.ttl.attribute_name
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_indexes
    content {
      name               = "${global_secondary_index.key}-global-index"
      hash_key           = global_secondary_index.key
      range_key          = global_secondary_index.value.range_key
      write_capacity     = global_secondary_index.value.write_capacity
      read_capacity      = global_secondary_index.value.read_capacity
      projection_type    = global_secondary_index.value.projection_type
      non_key_attributes = global_secondary_index.value.non_key_attributes
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_indexes
    content {
      name               = "${local_secondary_index.key}-local-index"
      range_key          = local_secondary_index.key
      projection_type    = local_secondary_index.value.projection_type
      non_key_attributes = local_secondary_index.value.non_key_attributes
    }
  }
}
