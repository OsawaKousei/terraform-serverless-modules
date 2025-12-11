variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "image_uri" {
  description = "URI of the container image in ECR"
  type        = string
}

variable "environment_variables" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
