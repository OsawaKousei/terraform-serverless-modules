variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "bucket_name_prefix" {
  description = "Prefix for S3 bucket name (account ID will be appended automatically)"
  type        = string
  default     = "my-csr-web-app"
}

variable "use_custom_domain" {
  description = "Whether to use a custom domain with CloudFront"
  type        = bool
  default     = false
}

variable "domain_name" {
  description = "Custom domain name for the web application (required if use_custom_domain is true)"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "ARN of ACM certificate in us-east-1 for CloudFront (required if use_custom_domain is true)"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for tagging"
  type        = string
  default     = "csr-web-app-sample"
}
