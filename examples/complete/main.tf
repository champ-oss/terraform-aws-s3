provider "aws" {
  region = "us-east-1"
}

locals {
  git = "terraform-aws-s3"
}

# Simple Example
module "this" {
  source  = "../../"
  git     = local.git
  protect = false # disabled just for testing
}

# For LB logging
module "lb_logs" {
  source           = "../../"
  git              = local.git
  protect          = false # disabled just for testing
  enable_lb_policy = true
}

# Use a customer KMS key
module "kms_key" {
  source                  = "github.com/champ-oss/terraform-aws-kms.git?ref=v1.0.9-b37e076"
  git                     = local.git
  name                    = "alias/${local.git}"
  deletion_window_in_days = 7
  account_actions         = []
}

module "kms" {
  source            = "../../"
  git               = local.git
  protect           = false # disabled just for testing
  sse_algorithm     = "aws:kms"
  kms_master_key_id = module.kms_key.key_id
}

# Expiration Enabled
module "expiration" {
  source                       = "../../"
  git                          = local.git
  protect                      = false # disabled just for testing
  expiration_lifecycle_enabled = true
  expiration_lifecycle_days    = 10
  expiration_lifecycle_prefix  = "/logs"
}

# Add an additional bucket policy
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["s3:GetBucketAcl"]
    resources = [
      "arn:aws:s3:::terraform-aws-s3-test",
      "arn:aws:s3:::terraform-aws-s3-test/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

module "policy" {
  source           = "../../"
  git              = local.git
  name             = "test"
  use_name_prefix  = false
  protect          = false # disabled just for testing
  policy           = data.aws_iam_policy_document.this.json
  enable_lb_policy = true
}