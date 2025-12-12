terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# csr-web-appモジュールを使用してReactアプリなどのCSRアプリをデプロイ
module "csr_web_app" {
  source = "../../modules/csr-web-app"

  bucket_name = "${var.bucket_name_prefix}-${data.aws_caller_identity.current.account_id}"

  # カスタムドメインを使用する場合
  domain_name         = var.use_custom_domain ? var.domain_name : null
  acm_certificate_arn = var.use_custom_domain ? var.acm_certificate_arn : null

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# 現在のAWSアカウントID取得
data "aws_caller_identity" "current" {}
