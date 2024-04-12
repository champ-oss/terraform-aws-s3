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
  source  = "../../"
  git     = "terraform-aws-s3"
  name    = "example"
  protect = false
}
