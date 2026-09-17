# Migration notes for the current unreleased version

This update fixes several inputs that previously did not create a working AWS configuration. Review the following items before upgrading an existing state.

## AWS provider

The minimum AWS provider version is now `6.64.0` because bucket ABAC and S3 Metadata use resources introduced in the current provider series.

## Bucket policy

The module now manages exactly one `aws_s3_bucket_policy.s3_default` resource. It merges the caller-supplied policy with the generated TLS-only statement.

If an existing deployment has only the old HTTPS policy address, move it before applying:

```shell
terraform state mv \
  'module.s3.aws_s3_bucket_policy.block-http[0]' \
  'module.s3.aws_s3_bucket_policy.s3_default[0]'
```

Adjust `module.s3` to the module address used by the caller. Inspect the plan carefully when both old policy resources are already present in state.

## ACLs and ownership

The old ACL count expression skipped normal canned ACL and grant configurations. ACL inputs now create an ACL resource. New S3 buckets commonly use `BucketOwnerEnforced`, which disables ACLs. Prefer removing `acl = "private"`; private access is already provided by S3 defaults and Public Access Block. When an ACL is genuinely required, configure:

```hcl
control_object_ownership = true
object_ownership         = "BucketOwnerPreferred"
```

The module now manages ownership controls by default with `BucketOwnerEnforced`, matching the secure default for new S3 buckets.

## Lifecycle transitions

Current-object and noncurrent-version transitions now have independent switches. Replace implicit noncurrent transitions with the applicable explicit inputs:

- `enable_noncurrent_version_glacier_transition`
- `enable_noncurrent_version_deeparchive_transition`
- `enable_noncurrent_version_standard_ia_transition`

Transition dates are RFC 3339 strings, matching the AWS provider, rather than numbers.

## Named configurations and outputs

Intelligent-Tiering, metrics, and inventory configurations now use each map key or explicit `name`, preventing multiple entries from overwriting the same AWS configuration. This can cause existing configurations to be replaced under their corrected names.

Absent optional outputs now return `null` instead of an empty string. Update callers that compare those outputs with `""`.
