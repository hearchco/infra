// this will get appended to region name
variable "bucket_name" {
  type = string
}

variable "path" {
  type    = string
  default = "tmp/s3"
}
