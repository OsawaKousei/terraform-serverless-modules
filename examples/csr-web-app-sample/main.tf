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
  region = "ap-northeast-1"
}

# csr-web-appモジュールを使用してReactアプリなどのCSRアプリをデプロイ
module "csr_web_app" {
  source = "../../modules/csr-web-app"

  bucket_name = "my-csr-web-app-sample-${data.aws_caller_identity.current.account_id}"

  # カスタムドメインを使用する場合は以下のコメントを解除
  domain_name         = "app.example.com"
  acm_certificate_arn = "arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012"

  tags = {
    Environment = "dev"
    Project     = "csr-web-app-sample"
    ManagedBy   = "Terraform"
  }
}

# 現在のAWSアカウントID取得
data "aws_caller_identity" "current" {}
