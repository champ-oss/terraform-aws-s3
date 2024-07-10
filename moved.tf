moved {
  from = aws_s3_bucket.this
  to   = aws_s3_bucket.this[0]
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.this
  to   = aws_s3_bucket_server_side_encryption_configuration.this[0]
}

moved {
  from = aws_s3_bucket_versioning.this
  to   = aws_s3_bucket_versioning.this[0]
}

moved {
  from = aws_s3_bucket_lifecycle_configuration.this
  to   = aws_s3_bucket_lifecycle_configuration.this[0]
}

moved {
  from = aws_s3_bucket_ownership_controls.this
  to   = aws_s3_bucket_ownership_controls.this[0]
}

moved {
  from = aws_s3_bucket_public_access_block.this
  to   = aws_s3_bucket_public_access_block.this[0]
}

