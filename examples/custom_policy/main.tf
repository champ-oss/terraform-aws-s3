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

module "this" {
  source               = "../../"
  git                  = "terraform-aws-s3"
  name                 = "test"
  use_name_prefix      = false
  protect              = false
  enable_custom_policy = true
  policy               = data.aws_iam_policy_document.this.json
  enable_lb_policy     = true
}