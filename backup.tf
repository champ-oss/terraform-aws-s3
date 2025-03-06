module "backup" {
  source       = "github.com/champ-oss/terraform-aws-backup.git?ref=develop"
  enabled      = var.enabled && var.enable_backup
  git          = var.git
  name         = var.name
  resource_arn = try(aws_s3_bucket.this[0].arn, null)
  protect      = var.protect
  #delete_after             = var.backup_delete_after
  #enable_continuous_backup = var.enable_continuous_backup
  #schedule                 = var.backup_schedule
  tags = merge(local.tags, var.tags)
}