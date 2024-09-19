locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }
}

# tflint-ignore: terraform_comment_syntax
//noinspection ConflictingProperties
resource "aws_s3_bucket" "this" {
  count         = var.enabled ? 1 : 0
  bucket        = var.use_name_prefix ? null : substr("${var.git}-${var.name}", 0, 63)  # 63 char limit
  bucket_prefix = var.use_name_prefix ? substr("${var.git}-${var.name}-", 0, 37) : null # 37 char limit on prefix
  force_destroy = !var.protect
  tags          = merge(local.tags, var.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  rule {
    id     = "expiration"
    status = var.expiration_lifecycle_enabled ? "Enabled" : "Disabled"
    filter {
      prefix = var.expiration_lifecycle_prefix
    }
    expiration {
      days = var.expiration_lifecycle_days
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.enabled ? 1 : 0
  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls
}

resource "aws_s3_bucket_policy" "this" {
  count  = (var.enable_custom_policy || var.enable_lb_policy || length(var.aws_cross_account_id_arns) != 0 || length(var.datasync_role_arn) != 0) && var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.combined[0].json
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  count  = var.enabled && var.enable_requester_pays ? 1 : 0
  bucket = aws_s3_bucket.this[0].bucket
  payer  = "Requester"
}

resource "aws_s3_bucket_cors_configuration" "example" {
  count  = var.enabled && var.enable_cors_configuration ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  dynamic "cors_rule" {
    for_each = var.cors_rules

    content {
      id              = cors_rule.value.id
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = cors_rule.value.allowed_headers
      expose_headers  = cors_rule.value.expose_headers
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}