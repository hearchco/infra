variable "path" {
  type    = string
  default = "tmp"
}

variable "filename" {
  type = string
}

# Use content instead of reading it from var.path/var.filename
variable "content" {
  type    = string
  default = null
}
