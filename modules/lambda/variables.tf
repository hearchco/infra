variable "name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "edge" {
  description = "Whether to publish the Lambda function to the edge"
  type        = bool
  default     = false
}

variable "handler" {
  description = "The entry point of the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime of the Lambda function"
  type        = string
}

variable "role" {
  description = "The IAM role attached to the Lambda function"
  type        = string
}

variable "src_s3_bucket" {
  description = "The S3 bucket where the Lambda function code is stored"
  type        = string
}

variable "src_s3_key" {
  description = "The S3 key where the Lambda function code is stored"
  type        = string
}

variable "src_hash" {
  description = "The hash of the Lambda function code"
  type        = string
}

variable "architecture" {
  description = "The architecture of the Lambda function"
  type        = string
  default     = "x86_64"
}

variable "memory_size" {
  description = "The memory size of the Lambda function"
  type        = number
  default     = 128
}

variable "timeout" {
  description = "The timeout of the Lambda function"
  type        = number
  default     = 10
}

variable "environment" {
  description = "The environment variables of the Lambda function, ignored for Lambda@Edge"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "keep_warm" {
  description = "Whether to keep the Lambda function warm by invoking it every 5 minutes"
  type        = bool
  default     = false
}
