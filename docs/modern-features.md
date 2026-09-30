# Modern S3 features

## Event notifications

The module can send S3 events to EventBridge, Lambda, SQS, and SNS. The destination policy or Lambda permission must allow S3 before AWS accepts the notification configuration.

```hcl
notification_configuration = {
  eventbridge = true

  lambda_functions = [{
    id                  = "images"
    lambda_function_arn = aws_lambda_function.processor.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"
  }]

  queues = [{
    queue_arn = aws_sqs_queue.deletions.arn
    events    = ["s3:ObjectRemoved:*"]
  }]

  topics = [{
    topic_arn     = aws_sns_topic.logs.arn
    events        = ["s3:ObjectCreated:*"]
    filter_suffix = ".log"
  }]
}
```

Amazon S3 replaces the complete notification configuration in one API call. Use only one Terraform resource/module to manage direct Lambda, SQS, and SNS notifications for a bucket. EventBridge is the safer option when independent stacks need to subscribe to the same bucket.

## Modern encryption controls

Use standard SSE-KMS with an S3 Bucket Key to reduce KMS request costs:

```hcl
sse_algorithm            = "aws:kms"
kms_master_key_id        = aws_kms_key.objects.arn
bucket_key_enabled       = true
blocked_encryption_types = ["SSE-C"]
```

For workloads requiring two encryption layers, use DSSE-KMS:

```hcl
sse_algorithm     = "aws:kms:dsse"
kms_master_key_id = aws_kms_key.objects.arn
```

S3 Bucket Keys are not supported with DSSE-KMS. The legacy `enable_kms = true` input always selects standard `aws:kms`; leave it false when selecting `aws:kms:dsse` directly.

## Partitioned server access logs

Partitioned keys make server access logs easier to query and organize:

```hcl
logging       = true
target_bucket = module.access_logs.id
target_prefix = "s3-access/"

logging_target_object_key_format = {
  partition_date_source = "EventTime"
}
```

Set `use_simple_prefix = true` instead when the legacy simple key format is required. AWS recommends granting log delivery through the destination bucket policy; `logging_target_grants` remains available for ACL-based integrations.

## Attribute-based access control

```hcl
abac_status = "Enabled"
tags = {
  Environment = "production"
  DataClass   = "confidential"
}
```

Audit IAM, Organizations, and bucket policies that use tag condition keys before enabling ABAC. Enabling it changes how bucket tags participate in authorization.

## Lifecycle transition object-size default

New or modified lifecycle configurations normally prevent objects smaller than 128 KB from transitioning to any storage class. To retain the older storage-class-specific behavior for Glacier Flexible Retrieval and Deep Archive, set:

```hcl
transition_default_minimum_object_size = "varies_by_storage_class"
```

An `object_size_greater_than` or `object_size_less_than` lifecycle rule filter takes precedence over this bucket-wide default.

## S3 Metadata tables

```hcl
metadata_configuration = {
  inventory_table_configuration = {
    configuration_state = "ENABLED"
    encryption_configuration = {
      sse_algorithm = "aws:kms"
      kms_key_arn   = aws_kms_key.metadata.arn
    }
  }

  journal_table_configuration = {
    record_expiration = {
      expiration = "ENABLED"
      days       = 30
    }
  }
}
```

S3 Metadata creates AWS-managed S3 Tables containing a live inventory and change journal. It is only available in supported Regions and can incur table storage, request, and initial inventory backfill charges. The caller also needs the S3 Metadata, S3 Tables, and related KMS permissions described by AWS.
