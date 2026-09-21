mock_provider "aws" {}

variables {
  s3_name = "module-basic-test"
}

run "validate_module" {
  command = plan

  assert {
    condition     = aws_s3_bucket.s3_default[0].bucket == "module-basic-test"
    error_message = "The module should pass s3_name to the S3 bucket."
  }
}
