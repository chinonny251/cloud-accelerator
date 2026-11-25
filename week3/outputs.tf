output "portfolio_bucket_arn" {
  value       = aws_s3_bucket.variable_bucket.arn
  description = "The permanent ARN of our portfolio storage resource"
}
