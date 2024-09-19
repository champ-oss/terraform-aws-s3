output "source_bucket" {
  description = "Source Bucket"
  value       = var.enabled ? module.source.bucket : ""
}

output "destination_bucket" {
  description = "Destination Bucket"
  value       = var.enabled ? module.destination.bucket : ""
}

output "enabled" {
  description = "module enabled"
  value       = var.enabled
}