locals {
  policy_names_map = {
    for behavior in var.ordered_cache_behaviors
    : behavior.path_pattern => "${behavior.cache_policy.min_ttl}-${behavior.cache_policy.default_ttl}-${behavior.cache_policy.max_ttl}"
  }

  origin_request_header_items = setunion(var.origin_request_header_items, var.additional_origin_request_header_items)
  cache_header_items          = setunion(var.cache_header_items, var.additional_cache_header_items)
}
