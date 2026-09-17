# Modern S3 bucket features

This example enables S3 Bucket Keys, SSE-C blocking, EventBridge notifications, bucket ABAC, and S3 Metadata journal and live inventory tables.

S3 Metadata is available only in supported AWS Regions and can incur storage and initial inventory backfill charges. Enabling ABAC also changes which S3 tagging permissions are used; audit tag-based IAM and bucket policies before enabling it in production.
