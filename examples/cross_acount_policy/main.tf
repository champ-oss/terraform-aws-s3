# example to add aws_cross_account_id_arns for read only bucket policy.  add one to many

/*
module "this" {
  source                          = "../../"
  git                             = "terraform-aws-s3"
  name                            = "test"
  use_name_prefix                 = false
  protect                         = false
  aws_cross_account_id_arns       = [
      "arn:aws:iam::111122223333:root",
      "arn:aws:iam::111122225555:root"
  ]
}
*/
