terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

variable "enabled" {
  description = "module enabled"
  type        = bool
  default     = true
}

module "source" {
  source                             = "../../"
  git                                = "terraform-aws-s3"
  name                               = "source"
  protect                            = false
  enable_replication                 = true
  replication_destination_bucket_arn = module.destination.arn
  enabled                            = var.enabled
  replication_destination_account_id = data.aws_caller_identity.source.account_id
}

data "aws_caller_identity" "source" {
}

module "destination" {
  source  = "../../"
  git     = "terraform-aws-s3"
  name    = "destination"
  protect = false
  enabled = var.enabled
}
