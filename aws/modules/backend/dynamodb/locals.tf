locals {
  hash_key = try(
    tolist([
      for attribute in var.attributes :
      attribute.name
      if attribute.hash_key == true
    ])[0],
    null
  )
  range_key = try(
    tolist([
      for attribute in var.attributes :
      attribute.name
      if attribute.range_key == true
    ])[0],
    null
  )
}
