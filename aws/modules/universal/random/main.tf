resource "random_integer" "length" {
  min = var.min_chars
  max = var.max_chars
}

resource "random_string" "string" {
  length  = random_integer.length.result
  upper   = var.upper
  lower   = var.lower
  numeric = var.numeric
  special = var.special
}
