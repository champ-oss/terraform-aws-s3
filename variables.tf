variable "git" {
  description = "Identifier to be used on all resources"
  type        = string
}

variable "name" {
  type        = string
  description = "Name used to identify the bucket"
  default     = "s3"
}

variable "use_name_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket_prefix"
  type        = bool
  default     = true
}

variable "tags" {
  description = "https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html"
  type        = map(string)
  default     = {}
}

variable "protect" {
  description = "Enables deletion protection on eligible resources"
  type        = bool
  default     = true
}

variable "object_ownership" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls#object_ownership"
  type        = string
  default     = "BucketOwnerEnforced"
}

variable "kms_master_key_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration#kms_master_key_id"
  type        = string
  default     = null
}

variable "sse_algorithm" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration#sse_algorithm"
  type        = string
  default     = "AES256"
}

variable "versioning" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning#status"
  type        = bool
  default     = true
}

variable "expiration_lifecycle_enabled" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#status"
  type        = bool
  default     = false
}

variable "expiration_lifecycle_days" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#days"
  type        = number
  default     = 90
}

variable "expiration_lifecycle_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#prefix"
  type        = string
  default     = "/"
}

variable "block_public_acls" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_acls"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_policy"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#restrict_public_buckets"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#ignore_public_acls"
  type        = bool
  default     = true
}

variable "enable_lb_policy" {
  description = "Enable Load Balancer log delivery policy"
  type        = bool
  default     = false
}

variable "policy" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#policy"
  type        = string
  default     = ""
}

variable "enable_requester_pays" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration"
  type        = bool
  default     = false
}

variable "enable_s3_inventory" {
  description = "enable or disable s3 inventory resource"
  type        = bool
  default     = false
}

variable "s3_inventory_frequency" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory#frequency"
  type        = string
  default     = "Daily"
}

variable "optional_fields" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory#optional_fields"
  type        = list(any)
  default     = ["Size", "EncryptionStatus", "LastModifiedDate", "ETag", "StorageClass"]
}

variable "inventory_destination_bucket_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory#bucket_arn"
  type        = string
  default     = ""
}

