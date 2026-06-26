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
