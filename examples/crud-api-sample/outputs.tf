output "api_endpoint" {
  description = "API GatewayのエンドポイントURL"
  value       = module.crud_api.api_endpoint
}

output "lambda_function_arn" {
  description = "Lambda関数のARN"
  value       = module.crud_api.lambda_function_arn
}

output "dynamodb_table_name" {
  description = "DynamoDBテーブル名"
  value       = module.crud_api.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDBテーブルのARN"
  value       = module.crud_api.dynamodb_table_arn
}
