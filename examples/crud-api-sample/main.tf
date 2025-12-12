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

# crud-apiモジュールを使用してCRUD APIをデプロイ
module "crud_api" {
  source = "../../modules/crud-api"

  name_prefix = var.name_prefix

  # ECRのイメージURI
  image_uri = var.image_uri

  # -------------------------------------------------------
  # DynamoDB Configuration (Updated for new Template)
  # -------------------------------------------------------
  table_name   = var.table_name
  billing_mode = var.billing_mode # 推奨: オンデマンドモード

  # Primary Key Definitions
  hash_key  = var.hash_key
  range_key = var.range_key

  # Attribute定義
  # ここには PKとSKの定義を含めます。
  # GSIを追加する場合は、そのキー定義もここに追加します。
  attributes = [
    { name = var.hash_key, type = "S" },
    { name = var.range_key, type = "S" }
  ]

  # GSI設定 (今回は不要なので空リスト)
  global_secondary_indexes = []

  # TTL設定 (必要な場合のみ指定。不要なら空文字)
  ttl_attribute = ""

  # セキュリティ設定
  deletion_protection_enabled = var.deletion_protection_enabled # 開発環境ではfalse、本番環境ではtrueを推奨
  pitr_enabled                = var.pitr_enabled                # Point-In-Time Recovery (コスト発生)

  # -------------------------------------------------------
  # Lambda & Other Settings
  # -------------------------------------------------------
  timeout               = var.lambda_timeout        # CRUD操作に十分なタイムアウト
  memory_size           = var.lambda_memory_size    # コンテナイメージに適したメモリサイズ
  log_retention_in_days = var.log_retention_in_days # 開発環境用の保持期間

  environment_variables = {
    DB_TYPE   = var.db_type
    LOG_LEVEL = var.log_level
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}
