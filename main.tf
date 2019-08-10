module "label" {
  source      = "git::https://github.com/clouddrove/terraform-labels.git?ref=tags/0.11.0"
  name        = "${var.name}"
  application = "${var.application}"
  environment = "${var.environment}"
}

resource "aws_s3_bucket" "s3" {
  count         = "${var.create_bucket ? 1 : 0}"
  bucket        = "${module.label.id}"
  region        = "${var.region}"
  acl           = "${var.acl}"
   versioning {
    enabled     = "${var.versioning}"
  }
}
