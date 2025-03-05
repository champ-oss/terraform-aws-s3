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
  source                   = "../../"
  git                      = "terraform-aws-s3"
  protect                  = false
  enable_backup            = true
  backup_delete_after      = 30
  enable_continuous_backup = true
}
