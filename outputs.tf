output "bucket" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#id"
  value       = aws_s3_bucket.this.bucket
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#arn"
  value       = aws_s3_bucket.this.arn
}