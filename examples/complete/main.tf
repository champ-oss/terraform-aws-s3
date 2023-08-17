module "this" {
  source  = "../../"
  git     = "terraform-aws-s3"
  name    = "example"
  protect = false
}