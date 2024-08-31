resource "aws_cloudfront_function" "cf_functions" {
  for_each = merge(
    {
      for cf_function in var.default_cache_behavior.function_associations
      : cf_function.name => cf_function.content
    },
    {
      for cf_function_name, cf_functions in {
        for cf_function in flatten([
          for cache_behavior in var.ordered_cache_behaviors
          : cache_behavior.function_associations
        ])
        : cf_function.name => cf_function...
      } : cf_function_name => cf_functions[0].content
    }
  )

  name    = each.key
  runtime = "cloudfront-js-2.0"
  publish = true
  code    = each.value
}
