module "this" {
  source                    = "../../"
  git                       = "terraform-aws-s3"
  name                      = "cors"
  protect                   = false
  enable_cors_configuration = true
  cors_rules = [
    {
      allowed_headers = ["*"]
      allowed_methods = ["PUT", "POST"]
      allowed_origins = ["https://s3-website-test.hashicorp.com"]
      max_age_seconds = 3000
    }
  ]
}