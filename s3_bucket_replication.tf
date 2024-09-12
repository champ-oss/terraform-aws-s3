data "aws_iam_policy_document" "replication_assume_role" {
  count = var.enabled && var.enable_replication ? 1 : 0
  statement {
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com", "batchoperations.s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  count              = var.enabled && var.enable_replication ? 1 : 0
  name_prefix        = substr("${var.git}-${var.name}-replication-", 0, 63)
  assume_role_policy = data.aws_iam_policy_document.replication_assume_role[0].json
}

data "aws_iam_policy_document" "replication" {
  count = var.enabled && var.enable_replication ? 1 : 0
  statement {
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
    ]
    resources = [aws_s3_bucket.this[0].arn]
  }

  statement {
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = ["${aws_s3_bucket.this[0].arn}/*"]
  }

  statement {
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
    ]
    resources = ["${var.replication_destination_bucket_arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  count       = var.enabled && var.enable_replication ? 1 : 0
  name_prefix = substr("${var.git}-${var.name}-replication-", 0, 63)
  policy      = data.aws_iam_policy_document.replication[0].json
}

resource "aws_iam_role_policy_attachment" "replication" {
  count      = var.enabled && var.enable_replication ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  count      = var.enabled && var.enable_replication ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.this]
  role       = aws_iam_role.replication[0].arn
  bucket     = aws_s3_bucket.this[0].id

  rule {
    status = "Enabled"
    filter {
      prefix = "/"
    }
    delete_marker_replication {
      status = var.replication_enable_delete_marker ? "Enabled" : "Disabled"
    }

    destination {
      bucket = var.replication_destination_bucket_arn
      access_control_translation {
        owner = "Destination"
      }
      account = var.replication_destination_account_id
      metrics {
        status = "Enabled"
      }
    }
  }
}