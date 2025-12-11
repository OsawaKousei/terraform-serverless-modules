output "api_endpoint" {
  description = "The URI of the API"
  value       = module.api.api_endpoint
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.api.lambda_function_arn
}

output "dynamodb_table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.this.name
}

output "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table"
  value       = aws_dynamodb_table.this.arn
}
