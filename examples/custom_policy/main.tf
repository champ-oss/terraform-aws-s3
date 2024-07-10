terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# Add an additional bucket policy
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::${module.this.bucket}",
      "arn:aws:s3:::${module.this.bucket}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

module "this" {
  source               = "../../"
  git                  = "terraform-aws-s3"
  name                 = "test"
  use_name_prefix      = true
  protect              = false
  enable_custom_policy = true
  policy               = data.aws_iam_policy_document.this.json
  enable_lb_policy     = true
}
