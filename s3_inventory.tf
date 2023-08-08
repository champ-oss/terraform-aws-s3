resource "aws_s3_bucket_inventory" "this" {
  count  = var.enable_s3_inventory ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = var.use_name_prefix ? aws_s3_bucket.this.bucket_prefix : aws_s3_bucket.this.bucket

  included_object_versions = "All"

  schedule {
    frequency = var.s3_inventory_frequency
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = aws_s3_bucket.this.arn
      prefix     = "inventory"
    }
  }
}
