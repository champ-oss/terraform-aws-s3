data "aws_iam_policy_document" "combined" {
  count = (length(var.datasync_cross_account_id_arn) != 0 || length(var.s3_read_write_cross_account_id_arns) != 0 || var.enable_custom_policy || var.enable_lb_policy || length(var.aws_cross_account_id_arns) != 0) && var.enabled ? 1 : 0 || var.enable_malware_protection_policy ? 1 : 0
  source_policy_documents = compact([
    var.enable_lb_policy ? data.aws_iam_policy_document.lb[0].json : "",
    var.enable_custom_policy ? var.policy : "",
    length(var.s3_read_write_cross_account_id_arns) != 0 ? data.aws_iam_policy_document.cross_account_s3_update[0].json : "",
    length(var.datasync_cross_account_id_arn) != 0 ? data.aws_iam_policy_document.data_sync_source[0].json : "",
    length(var.aws_cross_account_id_arns) != 0 ? data.aws_iam_policy_document.cross_account[0].json : "",
    var.enable_malware_protection_policy ? data.aws_iam_policy_document.gd_S3_malware_protection[0].json : ""
  ])
}

data "aws_elb_service_account" "this" {
  count = var.enable_lb_policy && var.enabled ? 1 : 0
}

data "aws_iam_policy_document" "lb" {
  count = var.enable_lb_policy && var.enabled ? 1 : 0

  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this[0].arn]
    }
  }

  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
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
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cross_account" {
  count = length(var.aws_cross_account_id_arns) != 0 && var.enabled ? 1 : 0

  statement {
    actions = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.aws_cross_account_id_arns
    }
  }
}

data "aws_iam_policy_document" "cross_account_s3_update" {
  count = length(var.s3_read_write_cross_account_id_arns) != 0 && var.enabled ? 1 : 0

  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:PutObject"
    ]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.s3_read_write_cross_account_id_arns
    }
  }
}

data "aws_iam_policy_document" "data_sync_source" {
  count = length(var.datasync_cross_account_id_arn) != 0 && var.enabled ? 1 : 0
  statement {
    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:AbortMultipartUpload"
    ]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = var.datasync_cross_account_id_arn
    }
  }
}

data "aws_iam_policy_document" "gd_S3_malware_protection" {
  count = var.enable_malware_protection_policy && var.enabled ? 1 : 0
  statement {
    # Tag based access control for GuardDuty Malware Protection enabled
    sid       = "DenyReadIfScannedNotClean"
    effect    = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:GetObject", "s3:GetObjectVersion"]
    resources = [aws_s3_bucket.this[0].arn]
    condition {
      # Tag is present
      test     = "Null"
      variable = "s3:ExistingObjectTag/GuardDutyMalwareScanStatus"
      values   = ["false"]
    }
    condition {
      # ...and its value is not clean
      test     = "StringNotEquals"
      variable = "s3:ExistingObjectTag/GuardDutyMalwareScanStatus"
      values   = ["NO_THREATS_FOUND"]
    }
    condition {
      # Scanner can still read objects
      test     = "ArnNotEquals"
      variable = "aws:PrincipalArn"
      values   = [aws_iam_role.guardduty_malware_protection_role[0].arn]
    }
  }
  statement {
    # Only GuardDuty may set, change, or remove object tags. Applies only to objects, not buckets.
    sid       = "DenyTagTampering"
    effect    = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:PutObjectTagging",
      "s3:PutObjectVersionTagging",
      "s3:DeleteObjectTagging",
      "s3:DeleteObjectVersionTagging",
    ]
    resources = ["arn:aws:s3:::${aws_s3_bucket.this[0].id}/*"]
    condition {
      test     = "ArnNotEquals"
      variable = "aws:PrincipalArn"
      values   = [aws_iam_role.guardduty_malware_protection_role[0].arn]
    }
  }
}