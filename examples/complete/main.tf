module "this" {
  source  = "../../"
  git     = "terraform-aws-s3"
  protect = false
}

output "arn" {
  value = module.this.arn
}