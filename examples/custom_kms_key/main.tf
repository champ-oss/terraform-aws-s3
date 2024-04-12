terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

# Create a customer KMS key
module "kms_key" {
  source                  = "github.com/champ-oss/terraform-aws-kms.git?ref=v1.0.31-3fc28eb"
  git                     = "terraform-aws-s3"
  name                    = "alias/terraform-aws-s3"
  deletion_window_in_days = 7
  account_actions         = []
}

module "this" {
  source            = "../../"
  git               = "terraform-aws-s3"
  protect           = false
  sse_algorithm     = "aws:kms"
  kms_master_key_id = module.kms_key.key_id
}
