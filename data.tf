data "aws_iam_policy_document" "combined" {
  count = (length(var.datasync_cross_account_id_arn) != 0 || length(var.s3_read_write_cross_account_id_arns) != 0 || var.enable_custom_policy || var.enable_lb_policy || length(var.aws_cross_account_id_arns) != 0) && var.enabled ? 1 : 0
  source_policy_documents = compact([
    var.enable_lb_policy ? data.aws_iam_policy_document.lb[0].json : "",
    var.enable_custom_policy ? var.policy : "",
    length(var.s3_read_write_cross_account_id_arns) != 0 ? data.aws_iam_policy_document.cross_account_s3_update[0].json : "",
    length(var.datasync_cross_account_id_arn) != 0 ? data.aws_iam_policy_document.data_sync_source[0].json : "",
    length(var.aws_cross_account_id_arns) != 0 ? data.aws_iam_policy_document.cross_account[0].json : ""
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
