variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "my-crud-api"
}

variable "image_uri" {
  description = "ECR image URI for the Lambda function"
  type        = string
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "MockTable"
}

variable "billing_mode" {
  description = "DynamoDB billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "hash_key" {
  description = "DynamoDB hash key (partition key)"
  type        = string
  default     = "method"
}

variable "range_key" {
  description = "DynamoDB range key (sort key)"
  type        = string
  default     = "path"
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "lambda_memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 512
}

variable "log_retention_in_days" {
  description = "CloudWatch Logs retention period in days"
  type        = number
  default     = 7
}

variable "deletion_protection_enabled" {
  description = "Enable DynamoDB deletion protection"
  type        = bool
  default     = false
}

variable "pitr_enabled" {
  description = "Enable Point-In-Time Recovery for DynamoDB"
  type        = bool
  default     = false
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "crud-api-sample"
}

variable "db_type" {
  description = "Database type for Lambda environment variable"
  type        = string
  default     = "dynamodb"
}

variable "log_level" {
  description = "Log level for Lambda function"
  type        = string
  default     = "INFO"
}
