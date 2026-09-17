<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.10.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.64.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.64.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_labels"></a> [labels](#module\_labels) | clouddrove/labels/aws | 1.3.1 |

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.s3_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_abac.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_abac) | resource |
| [aws_s3_bucket_accelerate_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_accelerate_configuration) | resource |
| [aws_s3_bucket_acl.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_analytics_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_analytics_configuration) | resource |
| [aws_s3_bucket_cors_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_cors_configuration) | resource |
| [aws_s3_bucket_intelligent_tiering_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_intelligent_tiering_configuration) | resource |
| [aws_s3_bucket_inventory.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_inventory) | resource |
| [aws_s3_bucket_lifecycle_configuration.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_logging.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_logging) | resource |
| [aws_s3_bucket_metadata_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metadata_configuration) | resource |
| [aws_s3_bucket_metric.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_metric) | resource |
| [aws_s3_bucket_notification.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_notification) | resource |
| [aws_s3_bucket_object_lock_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_object_lock_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.s3_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_replication_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_replication_configuration) | resource |
| [aws_s3_bucket_request_payment_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_request_payment_configuration) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_vpc_endpoint.endpoints](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_iam_policy_document.combined](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_vpc_endpoint_service.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abac_status"></a> [abac\_status](#input\_abac\_status) | Optional S3 bucket ABAC status. Valid values are Enabled and Disabled. | `string` | `null` | no |
| <a name="input_acceleration_status"></a> [acceleration\_status](#input\_acceleration\_status) | Whether to manage and enable the S3 Transfer Acceleration configuration. | `bool` | `false` | no |
| <a name="input_acl"></a> [acl](#input\_acl) | Canned ACL to apply to the S3 bucket. | `string` | `null` | no |
| <a name="input_acl_grants"></a> [acl\_grants](#input\_acl\_grants) | A list of policy grants for the bucket. Conflicts with `acl`. Set `acl` to `null` to use this. | <pre>list(object({<br/>    id         = optional(string)<br/>    type       = string<br/>    permission = string<br/>    uri        = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_analytics_configuration"></a> [analytics\_configuration](#input\_analytics\_configuration) | Map containing bucket analytics configuration. | `any` | `{}` | no |
| <a name="input_attach_public_policy"></a> [attach\_public\_policy](#input\_attach\_public\_policy) | Whether to manage the S3 bucket Public Access Block configuration. | `bool` | `true` | no |
| <a name="input_aws_iam_policy_document"></a> [aws\_iam\_policy\_document](#input\_aws\_iam\_policy\_document) | The text of the policy. Although this is a bucket policy rather than an IAM policy, the aws\_iam\_policy\_document data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Note: Bucket policies are limited to 20 KB in size. | `string` | `""` | no |
| <a name="input_block_http_bucket_policy"></a> [block\_http\_bucket\_policy](#input\_block\_http\_bucket\_policy) | Optional JSON policy document that replaces the generated statement used to deny non-HTTPS traffic. | `string` | `null` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_blocked_encryption_types"></a> [blocked\_encryption\_types](#input\_blocked\_encryption\_types) | Encryption types to reject for new object writes. Use ["SSE-C"] to block server-side encryption with customer-provided keys. | `list(string)` | `null` | no |
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Whether to use an S3 Bucket Key with SSE-KMS. Bucket Keys are not supported with DSSE-KMS. | `bool` | `false` | no |
| <a name="input_bucket_policy"></a> [bucket\_policy](#input\_bucket\_policy) | Conditionally create S3 bucket policy. | `bool` | `false` | no |
| <a name="input_bucket_prefix"></a> [bucket\_prefix](#input\_bucket\_prefix) | (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. | `string` | `null` | no |
| <a name="input_configuration_status"></a> [configuration\_status](#input\_configuration\_status) | Transfer Acceleration status. Valid values are Enabled and Suspended. | `string` | `"Enabled"` | no |
| <a name="input_control_object_ownership"></a> [control\_object\_ownership](#input\_control\_object\_ownership) | Whether to manage S3 Bucket Ownership Controls on this bucket. | `bool` | `true` | no |
| <a name="input_cors_rule"></a> [cors\_rule](#input\_cors\_rule) | CORS Configuration specification for this bucket | <pre>list(object({<br/>    id              = optional(string)<br/>    allowed_headers = optional(list(string), [])<br/>    allowed_methods = list(string)<br/>    allowed_origins = list(string)<br/>    expose_headers  = optional(list(string), [])<br/>    max_age_seconds = optional(number)<br/>  }))</pre> | `null` | no |
| <a name="input_enable_kms"></a> [enable\_kms](#input\_enable\_kms) | Enable KMS encryption. If false, uses AES256. | `bool` | `false` | no |
| <a name="input_enable_lifecycle_configuration_rules"></a> [enable\_lifecycle\_configuration\_rules](#input\_enable\_lifecycle\_configuration\_rules) | enable or disable lifecycle\_configuration\_rules | `bool` | `false` | no |
| <a name="input_enable_server_side_encryption"></a> [enable\_server\_side\_encryption](#input\_enable\_server\_side\_encryption) | Enable server-side encryption by default. | `bool` | `true` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Conditionally create S3 bucket. | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| <a name="input_expected_bucket_owner"></a> [expected\_bucket\_owner](#input\_expected\_bucket\_owner) | The account ID of the expected bucket owner | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | ACL Policy grant.conflict with acl.set acl null to use this | <pre>list(object({<br/>    id          = optional(string)<br/>    type        = string<br/>    permissions = list(string)<br/>    uri         = optional(string)<br/>  }))</pre> | `null` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| <a name="input_intelligent_tiering"></a> [intelligent\_tiering](#input\_intelligent\_tiering) | Map containing intelligent tiering configuration. | `any` | `{}` | no |
| <a name="input_inventory_configuration"></a> [inventory\_configuration](#input\_inventory\_configuration) | Map containing S3 inventory configuration. | `any` | `{}` | no |
| <a name="input_kms_master_key_id"></a> [kms\_master\_key\_id](#input\_kms\_master\_key\_id) | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms. | `string` | `null` | no |
| <a name="input_label_order"></a> [label\_order](#input\_label\_order) | Label order, e.g. `name`,`application`. | `list(string)` | `[]` | no |
| <a name="input_lifecycle_configuration_rules"></a> [lifecycle\_configuration\_rules](#input\_lifecycle\_configuration\_rules) | Lifecycle rules for current and noncurrent object transitions, expiration, filtering, and incomplete multipart upload cleanup. | <pre>list(object({<br/>    id      = string<br/>    enabled = optional(bool, true)<br/>    filter = optional(object({<br/>      prefix                   = optional(string)<br/>      tags                     = optional(map(string), {})<br/>      object_size_greater_than = optional(number)<br/>      object_size_less_than    = optional(number)<br/>    }))<br/><br/>    enable_glacier_transition                        = optional(bool, false)<br/>    enable_deeparchive_transition                    = optional(bool, false)<br/>    enable_standard_ia_transition                    = optional(bool, false)<br/>    enable_noncurrent_version_glacier_transition     = optional(bool, false)<br/>    enable_noncurrent_version_deeparchive_transition = optional(bool, false)<br/>    enable_noncurrent_version_standard_ia_transition = optional(bool, false)<br/>    enable_current_object_expiration                 = optional(bool, false)<br/>    enable_noncurrent_version_expiration             = optional(bool, false)<br/><br/>    abort_incomplete_multipart_upload_days         = optional(number)<br/>    noncurrent_version_glacier_transition_days     = optional(number)<br/>    noncurrent_version_deeparchive_transition_days = optional(number)<br/>    noncurrent_version_standard_ia_transition_days = optional(number)<br/>    noncurrent_version_expiration_days             = optional(number)<br/>    noncurrent_version_expiration_newer            = optional(number)<br/><br/>    noncurrent_version_glacier_transition_newer     = optional(number)<br/>    noncurrent_version_deeparchive_transition_newer = optional(number)<br/>    noncurrent_version_standard_ia_transition_newer = optional(number)<br/><br/>    storage_class = optional(string)<br/><br/>    glacier_storage_class     = optional(string)<br/>    deeparchive_storage_class = optional(string)<br/>    standard_ia_storage_class = optional(string)<br/><br/>    glacier_transition_date     = optional(string)<br/>    standard_ia_transition_date = optional(string)<br/>    deeparchive_transition_date = optional(string)<br/><br/>    standard_transition_days     = optional(number)<br/>    glacier_transition_days      = optional(number)<br/>    deeparchive_transition_days  = optional(number)<br/>    expiration_days              = optional(number)<br/>    expiration_date              = optional(string)<br/>    expired_object_delete_marker = optional(bool)<br/>  }))</pre> | `[]` | no |
| <a name="input_logging"></a> [logging](#input\_logging) | Logging Object to enable and disable logging | `bool` | `false` | no |
| <a name="input_logging_target_grants"></a> [logging\_target\_grants](#input\_logging\_target\_grants) | Target grants to apply to server access logging delivery. | <pre>list(object({<br/>    permission    = string<br/>    type          = string<br/>    id            = optional(string)<br/>    uri           = optional(string)<br/>    email_address = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_logging_target_object_key_format"></a> [logging\_target\_object\_key\_format](#input\_logging\_target\_object\_key\_format) | Server access log object key format. Set partition\_date\_source to EventTime or DeliveryTime for a partitioned prefix, or simple\_prefix to true. | <pre>object({<br/>    partition_date_source = optional(string)<br/>    simple_prefix         = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_managedby"></a> [managedby](#input\_managedby) | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| <a name="input_metadata_configuration"></a> [metadata\_configuration](#input\_metadata\_configuration) | S3 Metadata table configuration for the bucket. Metadata tables are available only in supported AWS Regions. | <pre>object({<br/>    inventory_table = optional(object({<br/>      configuration_state = optional(string, "ENABLED")<br/>      encryption = optional(object({<br/>        sse_algorithm = string<br/>        kms_key_arn   = optional(string)<br/>      }))<br/>    }))<br/>    journal_table = optional(object({<br/>      record_expiration = optional(object({<br/>        expiration = string<br/>        days       = optional(number)<br/>      }), { expiration = "DISABLED" })<br/>      encryption = optional(object({<br/>        sse_algorithm = string<br/>        kms_key_arn   = optional(string)<br/>      }))<br/>    }), {})<br/>  })</pre> | `null` | no |
| <a name="input_metric_configuration"></a> [metric\_configuration](#input\_metric\_configuration) | Map containing bucket metric configuration. | `any` | `[]` | no |
| <a name="input_mfa"></a> [mfa](#input\_mfa) | Optional, Required if versioning\_configuration mfa\_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `null` | no |
| <a name="input_mfa_delete"></a> [mfa\_delete](#input\_mfa\_delete) | Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. | `string` | `"Disabled"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| <a name="input_notification_configuration"></a> [notification\_configuration](#input\_notification\_configuration) | Complete S3 event notification configuration. This module manages the bucket's single atomic notification configuration. | <pre>object({<br/>    eventbridge = optional(bool, false)<br/>    lambda_functions = optional(list(object({<br/>      id                  = optional(string)<br/>      lambda_function_arn = string<br/>      events              = set(string)<br/>      filter_prefix       = optional(string)<br/>      filter_suffix       = optional(string)<br/>    })), [])<br/>    queues = optional(list(object({<br/>      id            = optional(string)<br/>      queue_arn     = string<br/>      events        = set(string)<br/>      filter_prefix = optional(string)<br/>      filter_suffix = optional(string)<br/>    })), [])<br/>    topics = optional(list(object({<br/>      id            = optional(string)<br/>      topic_arn     = string<br/>      events        = set(string)<br/>      filter_prefix = optional(string)<br/>      filter_suffix = optional(string)<br/>    })), [])<br/>  })</pre> | `null` | no |
| <a name="input_object_lock_configuration"></a> [object\_lock\_configuration](#input\_object\_lock\_configuration) | With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely. | <pre>object({<br/>    mode  = string # Valid values are GOVERNANCE and COMPLIANCE.<br/>    days  = optional(number)<br/>    years = optional(number)<br/>    token = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_object_lock_enabled"></a> [object\_lock\_enabled](#input\_object\_lock\_enabled) | Whether S3 bucket should have an Object Lock configuration enabled. | `bool` | `false` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL. | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_only_https_traffic"></a> [only\_https\_traffic](#input\_only\_https\_traffic) | Whether to add a bucket policy statement that denies requests made without TLS. | `bool` | `true` | no |
| <a name="input_owner"></a> [owner](#input\_owner) | Bucket owner's display name and ID. Conflicts with `acl` | `map(string)` | `{}` | no |
| <a name="input_owner_id"></a> [owner\_id](#input\_owner\_id) | The canonical user ID associated with the AWS account. | `string` | `""` | no |
| <a name="input_replication_configuration"></a> [replication\_configuration](#input\_replication\_configuration) | Map containing cross-region replication configuration. | `any` | `{}` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-s3"` | no |
| <a name="input_request_payer"></a> [request\_payer](#input\_request\_payer) | (Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information. | `string` | `null` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| <a name="input_s3_name"></a> [s3\_name](#input\_s3\_name) | name of s3 bucket | `string` | `null` | no |
| <a name="input_sse_algorithm"></a> [sse\_algorithm](#input\_sse\_algorithm) | The server-side encryption algorithm to use. Valid values are AES256, aws:kms, and aws:kms:dsse. | `string` | `"AES256"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources managed by the module (merged with module.labels.tags via extra\_tags). | `map(string)` | `{}` | no |
| <a name="input_target_bucket"></a> [target\_bucket](#input\_target\_bucket) | The bucket where you want Amazon S3 to store server access logs. | `string` | `""` | no |
| <a name="input_target_prefix"></a> [target\_prefix](#input\_target\_prefix) | A prefix for all log object keys. | `string` | `""` | no |
| <a name="input_timeouts"></a> [timeouts](#input\_timeouts) | Define maximum timeout for creating, updating, and deleting VPC endpoint resources | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable Versioning of S3. | `bool` | `true` | no |
| <a name="input_versioning_status"></a> [versioning\_status](#input\_versioning\_status) | Versioning state of the bucket. Valid values are Enabled, Suspended, and Disabled. | `string` | `"Enabled"` | no |
| <a name="input_vpc_endpoints"></a> [vpc\_endpoints](#input\_vpc\_endpoints) | List of VPC endpoint configurations to create for S3 access within a VPC. | `any` | `[]` | no |
| <a name="input_website"></a> [website](#input\_website) | Map containing static web-site hosting or redirect configuration. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_abac_status"></a> [abac\_status](#output\_abac\_status) | The configured bucket ABAC status, or null when ABAC is unmanaged. |
| <a name="output_arn"></a> [arn](#output\_arn) | The ARN of the s3 bucket. |
| <a name="output_bucket_domain_name"></a> [bucket\_domain\_name](#output\_bucket\_domain\_name) | The Domain of the s3 bucket. |
| <a name="output_bucket_regional_domain_name"></a> [bucket\_regional\_domain\_name](#output\_bucket\_regional\_domain\_name) | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| <a name="output_id"></a> [id](#output\_id) | The ID of the s3 bucket. |
| <a name="output_metadata_configuration"></a> [metadata\_configuration](#output\_metadata\_configuration) | The S3 Metadata configuration, including generated journal and inventory table details. |
| <a name="output_notification_configuration_id"></a> [notification\_configuration\_id](#output\_notification\_configuration\_id) | The bucket notification configuration ID, or null when notifications are not configured. |
| <a name="output_s3_bucket_hosted_zone_id"></a> [s3\_bucket\_hosted\_zone\_id](#output\_s3\_bucket\_hosted\_zone\_id) | The Route 53 Hosted Zone ID for this bucket's region. |
| <a name="output_s3_bucket_lifecycle_configuration_rules"></a> [s3\_bucket\_lifecycle\_configuration\_rules](#output\_s3\_bucket\_lifecycle\_configuration\_rules) | The lifecycle rules of the bucket, or null when lifecycle configuration is disabled. |
| <a name="output_s3_bucket_policy"></a> [s3\_bucket\_policy](#output\_s3\_bucket\_policy) | The combined bucket policy, including the HTTPS-only statement when enabled. |
| <a name="output_s3_bucket_website_domain"></a> [s3\_bucket\_website\_domain](#output\_s3\_bucket\_website\_domain) | The website endpoint domain, or null when website hosting is not configured. |
| <a name="output_s3_bucket_website_endpoint"></a> [s3\_bucket\_website\_endpoint](#output\_s3\_bucket\_website\_endpoint) | The website endpoint, or null when website hosting is not configured. |
| <a name="output_tags"></a> [tags](#output\_tags) | A mapping of tags to assign to the resource. |
<!-- END_TF_DOCS -->