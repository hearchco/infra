resource "random_integer" "length" {
  min = 48
  max = 64
}

resource "random_string" "string" {
  length  = random_integer.length.result
  special = false
}
