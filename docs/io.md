## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acceleration\_status | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended | `bool` | `false` | no |
| acl | Canned ACL to apply to the S3 bucket. | `string` | `null` | no |
| acl\_grants | A list of policy grants for the bucket. Conflicts with `acl`. Set `acl` to `null` to use this. | <pre>list(object({<br>    id         = string<br>    type       = string<br>    permission = string<br>    uri        = string<br>  }))</pre> | `null` | no |
| analytics\_configuration | Map containing bucket analytics configuration. | `any` | `{}` | no |
| attach\_public\_policy | Controls if a user defined public bucket policy will be attached (set to `false` to allow upstream to apply defaults to the bucket) | `bool` | `true` | no |
| aws\_iam\_policy\_document | The text of the policy. Although this is a bucket policy rather than an IAM policy, the aws\_iam\_policy\_document data source may be used, so long as it specifies a principal. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide. Note: Bucket policies are limited to 20 KB in size. | `string` | `""` | no |
| block\_http\_bucket\_policy | Custome bucket policy to block https traffic | `any` | `null` | no |
| block\_public\_acls | Whether Amazon S3 should block public ACLs for this bucket. | `bool` | `true` | no |
| block\_public\_policy | Whether Amazon S3 should block public bucket policies for this bucket. | `bool` | `true` | no |
| bucket\_policy | Conditionally create S3 bucket policy. | `bool` | `false` | no |
| bucket\_prefix | (Optional, Forces new resource) Creates a unique bucket name beginning with the specified prefix. | `string` | `null` | no |
| configuration\_status | Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. Disabled should only be used when creating or importing resources that correspond to unversioned S3 buckets. | `string` | `"Enabled"` | no |
| control\_object\_ownership | Whether to manage S3 Bucket Ownership Controls on this bucket. | `bool` | `false` | no |
| cors\_rule | CORS Configuration specification for this bucket | <pre>list(object({<br>    allowed_headers = list(string)<br>    allowed_methods = list(string)<br>    allowed_origins = list(string)<br>    expose_headers  = list(string)<br>    max_age_seconds = number<br>  }))</pre> | `null` | no |
| enable\_kms | Enable enable\_server\_side\_encryption | `bool` | `false` | no |
| enable\_lifecycle\_configuration\_rules | enable or disable lifecycle\_configuration\_rules | `bool` | `false` | no |
| enable\_server\_side\_encryption | Enable enable\_server\_side\_encryption | `bool` | `false` | no |
| enabled | Conditionally create S3 bucket. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| expected\_bucket\_owner | The account ID of the expected bucket owner | `string` | `null` | no |
| force\_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| grants | ACL Policy grant.conflict with acl.set acl null to use this | <pre>list(object({<br>    id          = string<br>    type        = string<br>    permissions = list(string)<br>    uri         = string<br>  }))</pre> | `null` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| intelligent\_tiering | Map containing intelligent tiering configuration. | `any` | `{}` | no |
| inventory\_configuration | Map containing S3 inventory configuration. | `any` | `{}` | no |
| kms\_master\_key\_id | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| lifecycle\_configuration\_rules | A list of lifecycle rules | <pre>list(object({<br>    id      = string<br>    enabled = bool<br>    filter  = any<br><br>    enable_glacier_transition            = bool<br>    enable_deeparchive_transition        = bool<br>    enable_standard_ia_transition        = bool<br>    enable_current_object_expiration     = bool<br>    enable_noncurrent_version_expiration = bool<br><br>    abort_incomplete_multipart_upload_days         = number<br>    noncurrent_version_glacier_transition_days     = number<br>    noncurrent_version_deeparchive_transition_days = number<br>    noncurrent_version_expiration_days             = number<br><br>    standard_transition_days    = number<br>    glacier_transition_days     = number<br>    deeparchive_transition_days = number<br>    expiration_days             = number<br>  }))</pre> | `null` | no |
| logging | Logging Object to enable and disable logging | `bool` | `false` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| metric\_configuration | Map containing bucket metric configuration. | `any` | `[]` | no |
| mfa | Optional, Required if versioning\_configuration mfa\_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `null` | no |
| mfa\_delete | Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. | `string` | `"Disabled"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| object\_lock\_configuration | With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely. | <pre>object({<br>    mode  = string #Valid values are GOVERNANCE and COMPLIANCE.<br>    days  = number<br>    years = number<br>  })</pre> | `null` | no |
| object\_lock\_enabled | Whether S3 bucket should have an Object Lock configuration enabled. | `bool` | `false` | no |
| object\_ownership | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. 'BucketOwnerEnforced': ACLs are disabled, and the bucket owner automatically owns and has full control over every object in the bucket. 'BucketOwnerPreferred': Objects uploaded to the bucket change ownership to the bucket owner if the objects are uploaded with the bucket-owner-full-control canned ACL. 'ObjectWriter': The uploading account will own the object if the object is uploaded with the bucket-owner-full-control canned ACL. | `string` | `"ObjectWriter"` | no |
| only\_https\_traffic | This veriables use for only https traffic. | `bool` | `true` | no |
| owner | Bucket owner's display name and ID. Conflicts with `acl` | `map(string)` | `{}` | no |
| owner\_id | The canonical user ID associated with the AWS account. | `string` | `""` | no |
| replication\_configuration | Map containing cross-region replication configuration. | `any` | `{}` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-s3"` | no |
| request\_payer | (Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. See Requester Pays Buckets developer guide for more information. | `string` | `null` | no |
| restrict\_public\_buckets | Whether Amazon S3 should restrict public bucket policies for this bucket. | `bool` | `true` | no |
| s3\_name | name of s3 bucket | `string` | `null` | no |
| sse\_algorithm | The server-side encryption algorithm to use. Valid values are AES256 and aws:kms. | `string` | `"AES256"` | no |
| target\_bucket | The bucket where you want Amazon S3 to store server access logs. | `string` | `""` | no |
| target\_prefix | A prefix for all log object keys. | `string` | `""` | no |
| timeouts | Define maximum timeout for creating, updating, and deleting VPC endpoint resources | `map(string)` | `{}` | no |
| versioning | Enable Versioning of S3. | `bool` | `true` | no |
| versioning\_status | Required if versioning\_configuration mfa\_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `"Enabled"` | no |
| vpc\_endpoints | n/a | `any` | `[]` | no |
| website | Map containing static web-site hosting or redirect configuration. | `any` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the s3 bucket. |
| bucket\_domain\_name | The Domain of the s3 bucket. |
| bucket\_regional\_domain\_name | The bucket region-specific domain name. The bucket domain name including the region name, please refer here for format. Note: The AWS CloudFront allows specifying S3 region-specific endpoint when creating S3 origin, it will prevent redirect issues from CloudFront to S3 Origin URL. |
| id | The ID of the s3 bucket. |
| s3\_bucket\_hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region. |
| s3\_bucket\_lifecycle\_configuration\_rules | The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. If not, this will be an empty string. |
| s3\_bucket\_policy | The policy of the bucket, if the bucket is configured with a policy. If not, this will be an empty string. |
| s3\_bucket\_website\_domain | The domain of the website endpoint, if the bucket is configured with a website. If not, this will be an empty string. This is used to create Route 53 alias records. |
| s3\_bucket\_website\_endpoint | The website endpoint, if the bucket is configured with a website. If not, this will be an empty string. |
| tags | A mapping of tags to assign to the resource. |
