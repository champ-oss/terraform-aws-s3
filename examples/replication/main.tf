terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

module "source" {
  source                             = "../../"
  git                                = "terraform-aws-s3"
  name                               = "source"
  protect                            = false
  enable_replication                 = true
  replication_destination_bucket_arn = module.destination.arn
}

module "destination" {
  source  = "../../"
  git     = "terraform-aws-s3"
  name    = "destination"
  protect = false
}
