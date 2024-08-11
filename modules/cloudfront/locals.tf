locals {
  policy_names_map = {
    for behavior in var.ordered_cache_behaviors
    : behavior.path_pattern => "${behavior.cache_policy.min_ttl}-${behavior.cache_policy.default_ttl}-${behavior.cache_policy.max_ttl}"
  }
}
