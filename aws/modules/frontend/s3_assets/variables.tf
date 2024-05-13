// this will get appended to region name
variable "bucket_name" {
  type = string
}

variable "bucket_name_suffix" {
  type      = string
  default   = ""
  sensitive = true
}

variable "path" {
  type    = string
  default = "tmp/s3"
}

variable "content_types" {
  type = map(string)
  default = {
    ".html"        = "text/html"
    ".css"         = "text/css"
    ".js"          = "application/javascript"
    ".json"        = "application/json"
    ".png"         = "image/png"
    ".jpg"         = "image/jpeg"
    ".jpeg"        = "image/jpeg"
    ".gif"         = "image/gif"
    ".svg"         = "image/svg+xml"
    ".ico"         = "image/x-icon"
    ".woff"        = "font/woff"
    ".woff2"       = "font/woff2"
    ".ttf"         = "font/ttf"
    ".otf"         = "font/otf"
    ".eot"         = "application/vnd.ms-fontobject"
    ".xml"         = "application/xml"
    ".txt"         = "text/plain"
    ".webmanifest" = "application/manifest+json"
  }
}
