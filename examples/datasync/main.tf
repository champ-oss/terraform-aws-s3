/*

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
  source                               = "../../"
  git                                  = "terraform-aws-s3"
  name                                 = "datasync-source"
  protect                              = false
  enable_datasync_policy_source_bucket = true
  replication_destination_bucket_arn   = module.destination.arn
  datasync_cross_account_id            = "123456789" # Datasync role arn for source bucket account
}

module "destination" {
  source                     = "../../"
  git                        = "terraform-aws-s3"
  name                       = "datasync-destination"
  protect                    = false
  enabled                    = var.enabled
  enable_datasync            = true
  datasync_source_bucket_arn = "arn:"
  # update cron to run every 1 minutes
  datasync_schedule_expression = "cron(0/1 * * * ? *)"
}

*/
