output "source_bucket" {
  description = "Source Bucket"
  value       = module.source.bucket
}

output "destination_bucket" {
  description = "Destination Bucket"
  value       = module.destination.bucket
}