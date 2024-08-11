locals {
  cache_policy_names_map = {
    for cache_behavior in var.ordered_cache_behaviors : cache_behavior.path_pattern => "${cache_behavior.policy.min_ttl}-${cache_behavior.policy.default_ttl}-${cache_behavior.policy.max_ttl}"
  }
}
