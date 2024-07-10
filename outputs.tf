output "bucket" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#id"
  value       = var.enabled ? aws_s3_bucket.this[0].bucket : ""
}

output "arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#arn"
  value       = var.enabled ? aws_s3_bucket.this[0].arn : ""
}

output "bucket_regional_domain_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket_regional_domain_name"
  value       = var.enabled ? aws_s3_bucket.this[0].bucket_regional_domain_name : ""
}
