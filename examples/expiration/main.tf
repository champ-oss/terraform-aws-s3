terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

module "this" {
  source                       = "../../"
  git                          = "terraform-aws-s3"
  protect                      = false
  expiration_lifecycle_enabled = true
  expiration_lifecycle_days    = 10
  expiration_lifecycle_prefix  = "/logs"
}
