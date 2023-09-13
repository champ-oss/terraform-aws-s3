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
  bucket        = var.use_name_prefix ? null : substr("${var.git}-${var.name}", 0, 63)  # 63 char limit
  bucket_prefix = var.use_name_prefix ? substr("${var.git}-${var.name}-", 0, 37) : null # 37 char limit on prefix
  force_destroy = !var.protect
  tags          = merge(local.tags, var.tags)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_master_key_id
      sse_algorithm     = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = var.versioning ? "Enabled" : "Disabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id
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
  bucket = aws_s3_bucket.this.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls      = var.ignore_public_acls
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.enable_custom_policy || var.enable_lb_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.combined[0].json
}

data "aws_iam_policy_document" "combined" {
  count = var.enable_custom_policy || var.enable_lb_policy ? 1 : 0
  source_policy_documents = compact([
    var.enable_lb_policy ? data.aws_iam_policy_document.lb[0].json : "",
    var.enable_custom_policy ? var.policy : ""
  ])
}

data "aws_elb_service_account" "this" {
  count = var.enable_lb_policy ? 1 : 0
}

data "aws_iam_policy_document" "lb" {
  count = var.enable_lb_policy ? 1 : 0

  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this[0].arn]
    }
  }

  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    actions = ["s3:GetBucketAcl"]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_request_payment_configuration" "this" {
  count  = var.enable_requester_pays ? 1 : 0
  bucket = aws_s3_bucket.this.bucket
  payer  = "Requester"
}
