# terraform-aws-s3

A Terraform module for creating an AWS S3 Bucket

[![.github/workflows/module.yml](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/module.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/module.yml)
[![.github/workflows/lint.yml](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/lint.yml)
[![.github/workflows/sonar.yml](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/sonar.yml/badge.svg)](https://github.com/champ-oss/terraform-aws-s3/actions/workflows/sonar.yml)

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-black.svg)](https://sonarcloud.io/summary/new_code?id=terraform-aws-s3_champ-oss)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-s3_champ-oss&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=terraform-aws-s3_champ-oss)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-s3_champ-oss&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=terraform-aws-s3_champ-oss)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-s3_champ-oss&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=terraform-aws-s3_champ-oss)

## Example Usage

See the `examples/` folder

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_request_payment_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acl"></a> [acl](#input\_acl) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl#acl | `string` | `"private"` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_acls | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#block_public_policy | `bool` | `true` | no |
| <a name="input_enable_lb_policy"></a> [enable\_lb\_policy](#input\_enable\_lb\_policy) | Enable Load Balancer log delivery policy | `bool` | `false` | no |
| <a name="input_enable_requester_pays"></a> [enable\_requester\_pays](#input\_enable\_requester\_pays) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration | `bool` | `false` | no |
| <a name="input_expiration_lifecycle_days"></a> [expiration\_lifecycle\_days](#input\_expiration\_lifecycle\_days) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#days | `number` | `90` | no |
| <a name="input_expiration_lifecycle_enabled"></a> [expiration\_lifecycle\_enabled](#input\_expiration\_lifecycle\_enabled) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#status | `bool` | `false` | no |
| <a name="input_expiration_lifecycle_prefix"></a> [expiration\_lifecycle\_prefix](#input\_expiration\_lifecycle\_prefix) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration#prefix | `string` | `"/"` | no |
| <a name="input_git"></a> [git](#input\_git) | Identifier to be used on all resources | `string` | n/a | yes |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#ignore_public_acls | `bool` | `true` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration#kms_master_key_id | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used to identify the bucket | `string` | `"s3"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy#policy | `string` | `""` | no |
| <a name="input_protect"></a> [protect](#input\_protect) | Enables deletion protection on eligible resources | `bool` | `true` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block#restrict_public_buckets | `bool` | `true` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration#sse_algorithm | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html | `map(string)` | `{}` | no |
| <a name="input_use_name_prefix"></a> [use\_name\_prefix](#input\_use\_name\_prefix) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#bucket_prefix | `bool` | `true` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning#status | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#arn |
| <a name="output_bucket"></a> [bucket](#output\_bucket) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#id |
<!-- END_TF_DOCS -->

## Features



## Contributing


