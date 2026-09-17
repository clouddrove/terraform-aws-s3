# terraform-aws-s3 basic example

This is a basic example of the `terraform-aws-s3` module.

## Usage

```hcl
module "s3" {
  source      = "clouddrove/s3/aws"
  name        = "s3"
  environment = "test"
}
```

## Current S3 features

The module also supports current general-purpose bucket settings such as EventBridge notifications, S3 Bucket Keys, DSSE-KMS, SSE-C blocking, bucket ABAC, and S3 Metadata tables:

```hcl
module "s3" {
  source = "clouddrove/s3/aws"

  name                     = "modern-s3"
  environment              = "test"
  sse_algorithm            = "aws:kms"
  bucket_key_enabled       = true
  blocked_encryption_types = ["SSE-C"]
  abac_status              = "Enabled"

  notification_configuration = {
    eventbridge = true
  }

  metadata_configuration = {
    inventory_table = {
      configuration_state = "ENABLED"
    }
  }
}
```

S3 Metadata is Region-dependent and can incur table storage and backfill charges. Destination policies or Lambda permissions required by event notifications must exist before the notification configuration is applied.
