module "this" {
  source                       = "../../"
  git                          = "terraform-aws-s3"
  protect                      = false
  expiration_lifecycle_enabled = true
  expiration_lifecycle_days    = 10
  expiration_lifecycle_prefix  = "/logs"
}
