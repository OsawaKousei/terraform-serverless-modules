output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution_id" {
  value = aws_cloudfront_distribution.this.id
}

output "s3_bucket_name" {
  value = aws_s3_bucket.website_bucket.id
}
