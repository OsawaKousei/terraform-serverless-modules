output "cloudfront_domain_name" {
  description = "CloudFrontのドメイン名"
  value       = module.csr_web_app.cloudfront_domain_name
}

output "distribution_id" {
  description = "CloudFront ディストリビューションID"
  value       = module.csr_web_app.distribution_id
}

output "s3_bucket_name" {
  description = "S3バケット名"
  value       = module.csr_web_app.s3_bucket_name
}
