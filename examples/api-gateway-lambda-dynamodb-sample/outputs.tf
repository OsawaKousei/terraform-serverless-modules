output "api_endpoint" {
  description = "API GatewayのエンドポイントURL"
  value       = module.serverless_api.api_endpoint
}

output "lambda_function_arn" {
  description = "Lambda関数のARN"
  value       = module.serverless_api.lambda_function_arn
}

output "dynamodb_table_name" {
  description = "DynamoDBテーブル名"
  value       = module.serverless_api.dynamodb_table_name
}

output "dynamodb_table_arn" {
  description = "DynamoDBテーブルのARN"
  value       = module.serverless_api.dynamodb_table_arn
}
