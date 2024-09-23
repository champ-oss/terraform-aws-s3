resource "random_string" "datasync" {
  count   = var.enable_datasync && var.enabled ? 1 : 0
  length  = 5
  special = false
  upper   = false
  lower   = true
}

resource "aws_datasync_task" "this" { # datasync task running on destination bucket account
  count                    = var.enable_datasync && var.enabled ? 1 : 0
  name                     = trimsuffix(substr("${var.git}-${random_string.datasync[0].result}", 0, 38), "-") # 38 char limit
  source_location_arn      = aws_datasync_location_s3.source[0].arn
  destination_location_arn = aws_datasync_location_s3.destination[0].arn

  schedule {
    schedule_expression = var.datasync_schedule_expression
  }
  tags = merge(local.tags, var.tags)
  options {
    bytes_per_second  = -1
    posix_permissions = "NONE"
    gid               = "NONE"
    uid               = "NONE"
  }
}

resource "aws_datasync_location_s3" "source" {
  count         = var.enable_datasync && var.enabled ? 1 : 0
  s3_bucket_arn = var.datasync_source_bucket_arn
  subdirectory  = "/"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync[0].arn
  }
  tags = merge(local.tags, var.tags)
}

resource "aws_iam_role" "datasync" {
  count       = var.enable_datasync && var.enabled ? 1 : 0
  name_prefix = substr("${var.git}-${var.name}-datasync-", 0, 63)

  assume_role_policy = data.aws_iam_policy_document.datasync[0].json
  tags               = merge(local.tags, var.tags)
}

data "aws_iam_policy_document" "datasync" {
  count = var.enable_datasync && var.enabled ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      identifiers = ["datasync.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy" "datasync" {
  count  = var.enable_datasync && var.enabled ? 1 : 0
  role   = aws_iam_role.datasync[0].id
  policy = data.aws_iam_policy_document.data_sync_destination[0].json
}

data "aws_iam_policy_document" "data_sync_destination" {
  count = var.enable_datasync && var.enabled ? 1 : 0
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      var.datasync_source_bucket_arn,
      "${var.datasync_source_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:AbortMultipartUpload",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:GetObjectVersionTagging",
      "s3:ListMultipartUploadParts",
      "s3:PutObject",
      "s3:PutObjectTagging"
    ]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
  }
}


resource "aws_datasync_location_s3" "destination" { # pull from source to destination
  count         = var.enable_datasync && var.enabled ? 1 : 0
  s3_bucket_arn = aws_s3_bucket.this[0].arn
  subdirectory  = "/"
  tags          = merge(local.tags, var.tags)
  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync[0].arn
  }
}
