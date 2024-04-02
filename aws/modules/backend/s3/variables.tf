variable "bucket_name" {
  type    = string
  default = "hearchco-binary"
}

variable "bucket_prefix" {
  type    = string
  default = ""
}

variable "path" {
  type    = string
  default = "tmp"
}

# Set of S3 bucket ARNs to replicate to
variable "buckets_to_replicate" {
  type    = map(string)
  default = {}
}

# If set to true, var.buckets_to_replicate will be ignored
variable "replica" {
  type    = bool
  default = false
}
