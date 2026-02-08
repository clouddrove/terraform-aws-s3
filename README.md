# Terraform AWS S3

[![Banner](https://github.com/clouddrove/terraform-module-template/assets/119565952/67a8a1af-2eb7-40b7-ae07-c94cde9ce062)][website]

[![Latest Release](https://img.shields.io/github/release/clouddrove/terraform-aws-s3.svg)](https://github.com/clouddrove/terraform-aws-s3/releases/latest)
[![tfsec](https://github.com/clouddrove/terraform-aws-s3/actions/workflows/tfsec.yml/badge.svg)](https://github.com/clouddrove/terraform-aws-s3/actions/workflows/tfsec.yml)
[![License](https://img.shields.io/badge/License-APACHE-blue.svg)](LICENSE.md)

**A secure, production-ready S3 module for AWS.**
Provision encrypted, versioned, and policy-protected S3 buckets with built-in SOC 2 defaults.

## 🚀 Quick Start

```hcl
module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "2.0.0"

  name        = "secure-logs-bucket"
  environment = "production"
  
  versioning = true
  enable_server_side_encryption = true
}
```

## ✨ Features

- **Secure by Default**:
  - Blocks Public Access (ACLs & Policies) automatically.
  - Enforces Server-Side Encryption (AES-256 or KMS).
  - Enforces HTTPS-only traffic.
- **Compliance Ready**:
  - Object Locking (WORM).
  - Versioning enabled.
  - Lifecycle Rules for cost optimization.
- **Integrated Logging**: Easy configuration for server access logs.

## 🛠️ Usage

### Advanced Example (KMS + Lifecycle + Logging)

```hcl
module "s3_bucket" {
  source  = "clouddrove/s3/aws"
  version = "2.0.0"

  name        = "app-data"
  environment = "prod"
  
  # Encryption
  enable_kms = true
  kms_master_key_id = "arn:aws:kms:us-east-1:123456789012:key/uuid"

  # Logging
  logging = true
  target_bucket = "my-access-logs"
  target_prefix = "logs/"

  # Lifecycle
  enable_lifecycle_configuration_rules = true
  lifecycle_configuration_rules = [
    {
      id      = "archive-old-data"
      enabled = true
      prefix  = "logs/"
      expiration_days = 365
      glacier_transition_days = 90
    }
  ]
}
```

## 📋 Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| acceleration\_status | Sets the accelerate configuration of an existing bucket. Can be Enabled or Suspended | `bool` | `false` | no |
| acl | Canned ACL to apply to the S3 bucket. | `string` | `null` | no |
| acl\_grants | A list of policy grants for the bucket. Conflicts with `acl`. Set `acl` to `null` to use this. | `list(object({ id = string, type = string, permission = string, uri = string }))` | `null` | no |
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
| cors\_rule | CORS Configuration specification for this bucket | `list(object({ allowed_headers = list(string), allowed_methods = list(string), allowed_origins = list(string), expose_headers = list(string), max_age_seconds = number }))` | `null` | no |
| enable\_kms | Enable KMS encryption. If false, uses AES256. | `bool` | `false` | no |
| enable\_lifecycle\_configuration\_rules | enable or disable lifecycle\_configuration\_rules | `bool` | `false` | no |
| enable\_server\_side\_encryption | Enable server-side encryption by default. | `bool` | `true` | no |
| enabled | Conditionally create S3 bucket. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| expected\_bucket\_owner | The account ID of the expected bucket owner | `string` | `null` | no |
| force\_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| grants | ACL Policy grant.conflict with acl.set acl null to use this | `list(object({ id = string, type = string, permissions = list(string), uri = string }))` | `null` | no |
| ignore\_public\_acls | Whether Amazon S3 should ignore public ACLs for this bucket. | `bool` | `true` | no |
| intelligent\_tiering | Map containing intelligent tiering configuration. | `any` | `{}` | no |
| inventory\_configuration | Map containing S3 inventory configuration. | `any` | `{}` | no |
| kms\_master\_key\_id | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse\_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse\_algorithm is aws:kms. | `string` | `""` | no |
| label\_order | Label order, e.g. `name`,`application`. | `list(any)` | `[]` | no |
| lifecycle\_configuration\_rules | A list of lifecycle rules | `list(object({ id = string, enabled = bool, filter = any, enable_glacier_transition = bool, enable_deeparchive_transition = bool, enable_standard_ia_transition = bool, enable_current_object_expiration = bool, enable_noncurrent_version_expiration = bool, abort_incomplete_multipart_upload_days = number, noncurrent_version_glacier_transition_days = number, noncurrent_version_deeparchive_transition_days = number, noncurrent_version_expiration_days = number, standard_transition_days = number, glacier_transition_days = number, deeparchive_transition_days = number, expiration_days = number }))` | `null` | no |
| logging | Logging Object to enable and disable logging | `bool` | `false` | no |
| managedby | ManagedBy, eg 'CloudDrove'. | `string` | `"hello@clouddrove.com"` | no |
| metric\_configuration | Map containing bucket metric configuration. | `any` | `[]` | no |
| mfa | Optional, Required if versioning\_configuration mfa\_delete is enabled) Concatenation of the authentication device's serial number, a space, and the value that is displayed on your authentication device. | `string` | `null` | no |
| mfa\_delete | Specifies whether MFA delete is enabled in the bucket versioning configuration. Valid values: Enabled or Disabled. | `string` | `"Disabled"` | no |
| name | Name  (e.g. `app` or `cluster`). | `string` | `""` | no |
| object\_lock\_configuration | With S3 Object Lock, you can store objects using a write-once-read-many (WORM) model. Object Lock can help prevent objects from being deleted or overwritten for a fixed amount of time or indefinitely. | `object({ mode = string, days = number, years = number })` | `null` | no |
| object\_lock\_enabled | Whether S3 bucket should have an Object Lock configuration enabled. | `bool` | `false` | no |
| object\_ownership | Object ownership. Valid values: BucketOwnerEnforced, BucketOwnerPreferred or ObjectWriter. | `string` | `"ObjectWriter"` | no |
| only\_https\_traffic | This veriables use for only https traffic. | `bool` | `true` | no |
| owner | Bucket owner's display name and ID. Conflicts with `acl` | `map(string)` | `{}` | no |
| owner\_id | The canonical user ID associated with the AWS account. | `string` | `""` | no |
| replication\_configuration | Map containing cross-region replication configuration. | `any` | `{}` | no |
| repository | Terraform current module repo | `string` | `"https://github.com/clouddrove/terraform-aws-s3"` | no |
| request\_payer | (Optional) Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. | `string` | `null` | no |
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
| bucket\_regional\_domain\_name | The bucket region-specific domain name. |
| id | The ID of the s3 bucket. |
| s3\_bucket\_hosted\_zone\_id | The Route 53 Hosted Zone ID for this bucket's region. |
| s3\_bucket\_lifecycle\_configuration\_rules | The lifecycle rules of the bucket, if the bucket is configured with lifecycle rules. |
| s3\_bucket\_policy | The policy of the bucket, if the bucket is configured with a policy. |
| s3\_bucket\_website\_domain | The domain of the website endpoint, if the bucket is configured with a website. |
| s3\_bucket\_website\_endpoint | The website endpoint, if the bucket is configured with a website. |
| tags | A mapping of tags to assign to the resource. |

## 🤝 Community

- **Slack:** [Join our DevOps community](https://www.launchpass.com/devops-talks).
- **Contributing:** PRs are welcome! Check our [contribution guide](.github/CONTRIBUTING.md).
- **Issues:** [Report bugs here](https://github.com/clouddrove/terraform-aws-s3/issues).

## 📄 License

Apache 2.0. See [LICENSE](LICENSE.md) for full details.

---

<p align="center">
  <a href="https://clouddrove.com">
    <img src="https://clouddrove.com/assets/img/logo.png" width="200" alt="CloudDrove" />
  </a>
</p>
