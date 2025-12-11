output "api_endpoint" {
  description = "The URI of the API"
  value       = aws_apigatewayv2_api.http_api.api_endpoint
}

output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = module.lambda.function_arn
}

output "lambda_role_name" {
  description = "Name of the IAM role attached to the Lambda function"
  value       = module.lambda.role_name
}
