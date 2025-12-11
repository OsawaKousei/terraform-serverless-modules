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

# crud-apiモジュールを使用してCRUD APIをデプロイ
module "crud_api" {
  source = "../../modules/crud-api"

  name_prefix = "my-crud-api"

  # ECRのイメージURIを指定
  # 例: "123456789012.dkr.ecr.ap-northeast-1.amazonaws.com/my-app:latest"
  image_uri = var.image_uri

  # DynamoDBテーブル名（オプション。指定しない場合は{name_prefix}-tableが使用されます）
  # dynamodb_table_name = "my-custom-table-name"

  # DynamoDBの課金モード（デフォルト: PAY_PER_REQUEST）
  # dynamodb_billing_mode = "PROVISIONED"

  tags = {
    Environment = "dev"
    Project     = "crud-api-sample"
    ManagedBy   = "Terraform"
  }
}
