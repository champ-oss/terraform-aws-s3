resource "aws_s3_bucket_inventory" "this" {
  count  = var.enable_s3_inventory ? 1 : 0
  bucket = aws_s3_bucket.this.id
  name   = "inventory"

  included_object_versions = "Current"
  optional_fields          = var.optional_fields
  schedule {
    frequency = var.s3_inventory_frequency
  }

  destination {
    bucket {
      format     = "CSV"
      bucket_arn = var.inventory_destination_bucket_arn != "" ? var.inventory_destination_bucket_arn : aws_s3_bucket.this.arn
      prefix     = "inventory"
    }
  }
}
