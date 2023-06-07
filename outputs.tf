output "bucket" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#id"
  value       = aws_s3_bucket.this.bucket
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#arn"
  value       = aws_s3_bucket.this.arn
}

output "bucket_regional_domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket_regional_domain_name"
  value       = aws_s3_bucket.this.bucket_regional_domain_name
}
