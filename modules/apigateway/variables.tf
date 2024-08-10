variable "name" {
  description = "The name of the API Gateway"
  type        = string
}

variable "domain_name" {
  description = "The domain name for the API Gateway"
  type        = string
}

variable "hosted_zone_id" {
  description = "The hosted zone ID of the wanted domain"
  type        = string
}

variable "acm_certificate_arn" {
  description = "The ARN of the ACM certificate"
  type        = string
}

variable "invoke_arn" {
  description = "The ARN of the Lambda function to integrate with the API Gateway"
  type        = string
}

variable "function_name" {
  description = "The name of the Lambda function to integrate with the API Gateway"
  type        = string
}

variable "integration_type" {
  description = "The integration type for the API Gateway"
  type        = string
  default     = "AWS_PROXY"
}

variable "integration_method" {
  description = "The integration method for the API Gateway"
  type        = string
  default     = "POST"
}

variable "payload_format_version" {
  description = "The payload format version for the API Gateway"
  type        = string
  default     = "2.0"
}

variable "connection_type" {
  description = "The connection type for the API Gateway"
  type        = string
  default     = "INTERNET"
}

variable "stage_name" {
  description = "The name of the stage for the API Gateway"
  type        = string
  default     = "$default"
}

variable "auto_deploy" {
  description = "Whether to automatically deploy the API Gateway"
  type        = bool
  default     = true
}

variable "routes" {
  description = "The routes for the API Gateway"
  type        = set(string)
}
