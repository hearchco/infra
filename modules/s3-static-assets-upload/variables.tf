variable "bucket_name" {
  description = "The name of the bucket to upload the source code to, the region and account ID will be appended to this name"
  type        = string
}

variable "bucket_name_suffix" {
  description = "Used to obfuscate the bucket name"
  type        = string
  default     = ""
  sensitive   = true
}

variable "assets_path" {
  description = "The path to the folder containing assets to upload to the bucket"
  type        = string
}

variable "content_types" {
  description = "A map of file extensions to content types"
  type        = map(string)
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
