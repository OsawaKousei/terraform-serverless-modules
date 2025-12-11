locals {
  table_name = var.dynamodb_table_name != "" ? var.dynamodb_table_name : "${var.name_prefix}-table"
}

module "api" {
  source = "../rest-api"

  name_prefix = var.name_prefix
  image_uri   = var.image_uri

  environment_variables = {
    DYNAMODB_TABLE_NAME = local.table_name
  }

  tags = var.tags
}

resource "aws_dynamodb_table" "this" {
  name         = local.table_name
  billing_mode = var.dynamodb_billing_mode
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = var.tags
}

resource "aws_iam_policy" "dynamodb_access" {
  name        = "${var.name_prefix}-dynamodb-policy"
  description = "IAM policy for accessing DynamoDB table"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:GetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:BatchWriteItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem"
        ]
        Effect   = "Allow"
        Resource = aws_dynamodb_table.this.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_access_attachment" {
  role       = module.api.lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}
