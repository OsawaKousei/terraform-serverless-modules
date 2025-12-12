locals {
  table_name = var.table_name != "" ? var.table_name : "${var.name_prefix}-table"
}

module "api" {
  source = "../rest-api"

  name_prefix = var.name_prefix
  image_uri   = var.image_uri

  environment_variables = merge(
    {
      DYNAMODB_TABLE_NAME = local.table_name
    },
    var.environment_variables
  )

  timeout               = var.timeout
  memory_size           = var.memory_size
  log_retention_in_days = var.log_retention_in_days

  tags = var.tags
}

module "dynamodb" {
  source = "../dynamodb-table"

  table_name                  = local.table_name
  billing_mode                = var.billing_mode
  hash_key                    = var.hash_key
  range_key                   = var.range_key
  attributes                  = var.attributes
  global_secondary_indexes    = var.global_secondary_indexes
  ttl_attribute               = var.ttl_attribute
  deletion_protection_enabled = var.deletion_protection_enabled
  pitr_enabled                = var.pitr_enabled
  read_capacity               = var.read_capacity
  write_capacity              = var.write_capacity

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
        Resource = module.dynamodb.table_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "dynamodb_access_attachment" {
  role       = module.api.lambda_role_name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}
