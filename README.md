<!-- This file was automatically generated by the `geine`. Make all changes to `README.yaml` and run `make readme` to rebuild this file. -->

<p align="center"> <img src="https://user-images.githubusercontent.com/50652676/62349836-882fef80-b51e-11e9-99e3-7b974309c7e3.png" width="100" height="100"></p>


<h1 align="center">
    Terraform AWS S3
</h1>

<p align="center" style="font-size: 1.2rem;">
    Terraform module to create default S3 bucket with logging and encryption type specific features.
     </p>

<p align="center">

<a href="https://www.terraform.io">
  <img src="https://img.shields.io/badge/Terraform-v0.12-green" alt="Terraform">
</a>
<a href="LICENSE.md">
  <img src="https://img.shields.io/badge/License-MIT-blue.svg" alt="Licence">
</a>


</p>
<p align="center">

<a href='https://facebook.com/sharer/sharer.php?u=https://github.com/clouddrove/terraform-aws-s3'>
  <img title="Share on Facebook" src="https://user-images.githubusercontent.com/50652676/62817743-4f64cb80-bb59-11e9-90c7-b057252ded50.png" />
</a>
<a href='https://www.linkedin.com/shareArticle?mini=true&title=Terraform+AWS+S3&url=https://github.com/clouddrove/terraform-aws-s3'>
  <img title="Share on LinkedIn" src="https://user-images.githubusercontent.com/50652676/62817742-4e339e80-bb59-11e9-87b9-a1f68cae1049.png" />
</a>
<a href='https://twitter.com/intent/tweet/?text=Terraform+AWS+S3&url=https://github.com/clouddrove/terraform-aws-s3'>
  <img title="Share on Twitter" src="https://user-images.githubusercontent.com/50652676/62817740-4c69db00-bb59-11e9-8a79-3580fbbf6d5c.png" />
</a>

</p>
<hr>


We eat, drink, sleep and most importantly love **DevOps**. We are working towards stratergies for standardizing architecture while ensuring security for the infrastructure. We are strong believer of the philosophy <b>Bigger problems are always solved by breaking them into smaller manageable problems</b>. Resonating with microservices architecture, it is considered best-practice to run database, cluster, storage in smaller <b>connected yet manageable pieces</b> within the infrastructure.

This module is basically combination of [Terraform open source](https://www.terraform.io/) and includes automatation tests and examples. It also helps to create and improve your infrastructure with minimalistic code instead of maintaining the whole infrastructure code yourself.

We have [*fifty plus terraform modules*][terraform_modules]. A few of them are comepleted and are available for open source usage while a few others are in progress.




## Prerequisites

This module has a few dependencies:

- [Terraform 0.12](https://learn.hashicorp.com/terraform/getting-started/install.html)
- [Go](https://golang.org/doc/install)
- [github.com/stretchr/testify/assert](https://github.com/stretchr/testify)
- [github.com/gruntwork-io/terratest/modules/terraform](https://github.com/gruntwork-io/terratest)







## Examples


**IMPORTANT:** Since the `master` branch used in `source` varies based on new modifications, we suggest that you use the release versions [here](https://github.com/clouddrove/terraform-aws-s3/releases).


Here are some examples of how you can use this module in your inventory structure:
### Basic Bucket
```hcl
module "s3_bucket" {
  source              = "https://github.com/clouddrove/terraform-aws-s3?ref=tags/0.12.5"
  name                = "secure-bucket"
  region              = "eu-west-1"
  application         = "clouddrove"
  environment         = "test"
  label_order         = ["environment", "application", "name"]
  versioning          = true
  acl                 = "private"
  bucket_enabled      = true
}
```
### Encryption Bucket
```hcl
module "s3_bucket" {
  source                     = "https://github.com/clouddrove/terraform-aws-s3?ref=tags/0.12.5"
  name                       = "encryption-bucket"
  region                     = "eu-west-1"
  application                = "clouddrove"
  environment                = "test"
  label_order                = ["environment", "application", "name"]
  versioning                 = true
  acl                        = "private"
  bucket_encryption_enabled  = true
  sse_algorithm              = "AES256"
}
### Logging-Encryption Bucket
```hcl
module "s3_bucket" {
  source                             = "https://github.com/clouddrove/terraform-aws-s3?ref=tags/0.12.5"
  name                               = "logging-encryption-bucket"
  region                             = "eu-west-1"
  application                        = "clouddrove"
  environment                        = "test"
  label_order                        = ["environment", "application", "name"]
  versioning                         = true
  acl                                = "private"
  bucket_logging_encryption_enabled  = true
  sse_algorithm                      = "AES256"
  target_bucket                      = "bucket-logs12"
  target_prefix                      = "logs"
}
```
### Logging Bucket
```hcl
module "s3_bucket" {
  source                  = "https://github.com/clouddrove/terraform-aws-s3?ref=tags/0.12.5"
  name                    = "logging-bucket"
  region                  = "eu-west-1"
  application             = "clouddrove"
  environment             = "test"
  label_order             = ["environment", "application", "name"]
  versioning              = true
  acl                     = "private"
  bucket_logging_enabled  = true
  target_bucket           = "bucket-logs12"
  target_prefix           = "logs"
}
```
### Website Host Bucket
```hcl
module "s3_bucket" {
  source                              = "https://github.com/clouddrove/terraform-aws-s3?ref=tags/0.12.5"
  name                                = "website-bucket"
  region                              = "eu-west-1"
  application                         = "clouddrove"
  environment                         = "test"
  label_order                         = ["environment", "application", "name"]
  versioning                          = true
  acl                                 = "private"
  website_hosting_bucket              = true
  website_index                       = "index.html"
  website_error                       = "error.html"
  bucket_policy                       = true
  lifecycle_expiration_enabled        = true
  lifecycle_expiration_object_prefix  = "test"
  lifecycle_days_to_expiration        = 10
  aws_iam_policy_document             = data.aws_iam_policy_document.default.json
}
data "aws_iam_policy_document" "default" {
  version = "2012-10-17"
  statement {
       sid = "Stmt1447315805704"
       effect = "Allow"
       principals {
            type = "AWS"
            identifiers = ["*"]
          }
       actions = ["s3:GetObject"]
       resources = ["arn:aws:s3:::test-website-bucket-clouddrove/*"]
   }
}
```






## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| acl | Canned ACL to apply to the S3 bucket. | string | `` | no |
| application | Application (e.g. `cd` or `clouddrove`). | string | `` | no |
| attributes | Additional attributes (e.g. `1`). | list | `<list>` | no |
| aws_iam_policy_document | Specifies the number of days after object creation when the object expires. | string | `` | no |
| bucket_enabled | Enable simple S3. | bool | `false` | no |
| bucket_encryption_enabled | Enable encryption of S3. | bool | `false` | no |
| bucket_logging_enabled | Enable logging of S3. | bool | `false` | no |
| bucket_logging_encryption_enabled | Enable logging encryption of S3. | bool | `false` | no |
| bucket_policy | Conditionally create S3 bucket policy. | bool | `false` | no |
| create_bucket | Conditionally create S3 bucket. | bool | `true` | no |
| delimiter | Delimiter to be used between `organization`, `environment`, `name` and `attributes`. | string | `-` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | string | `` | no |
| force_destroy | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | bool | `false` | no |
| kms_master_key_id | The AWS KMS master key ID used for the SSE-KMS encryption. This can only be used when you set the value of sse_algorithm as aws:kms. The default aws/s3 AWS KMS master key is used if this element is absent while the sse_algorithm is aws:kms. | string | `` | no |
| label_order | Label order, e.g. `name`,`application`. | list | `<list>` | no |
| lifecycle_days_to_expiration | Specifies the number of days after object creation when the object expires. | number | `365` | no |
| lifecycle_days_to_glacier_transition | Specifies the number of days after object creation when it will be moved to Glacier storage. | number | `180` | no |
| lifecycle_days_to_infrequent_storage_transition | Specifies the number of days after object creation when it will be moved to standard infrequent access storage. | number | `60` | no |
| lifecycle_expiration_enabled | Specifies expiration lifecycle rule status. | bool | `false` | no |
| lifecycle_expiration_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | string | `` | no |
| lifecycle_glacier_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | string | `` | no |
| lifecycle_glacier_transition_enabled | Specifies Glacier transition lifecycle rule status. | bool | `false` | no |
| lifecycle_infrequent_storage_object_prefix | Object key prefix identifying one or more objects to which the lifecycle rule applies. | string | `` | no |
| lifecycle_infrequent_storage_transition_enabled | Specifies infrequent storage transition lifecycle rule status. | bool | `false` | no |
| managedby | ManagedBy, eg 'CloudDrove' or 'AnmolNagpal'. | string | `anmol@clouddrove.com` | no |
| name | Name  (e.g. `app` or `cluster`). | string | `` | no |
| region | Region Where you want to host S3. | string | `` | no |
| sse_algorithm | The server-side encryption algorithm to use. Valid values are AES256 and aws:kms. | string | `AES256` | no |
| tags | Additional tags (e.g. map(`BusinessUnit`,`XYZ`). | map | `<map>` | no |
| target_bucket | The name of the bucket that will receive the log objects. | string | `` | no |
| target_prefix | To specify a key prefix for log objects. | string | `` | no |
| versioning | Enable Versioning of S3. | bool | `false` | no |
| website_error | An absolute path to the document to return in case of a 4XX error. | string | `error.html` | no |
| website_hosting_bucket | Enable website hosting of S3. | bool | `false` | no |
| website_index | Amazon S3 returns this index document when requests are made to the root domain or any of the subfolders. | string | `index.html` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the s3 bucket. |
| bucket_domain_name | The Domain of the s3 bucket. |
| id | The ID of the s3 bucket. |
| tags | A mapping of tags to assign to the resource. |




## Testing
In this module testing is performed with [terratest](https://github.com/gruntwork-io/terratest) and it creates a small piece of infrastructure, matches the output like ARN, ID and Tags name etc and destroy infrastructure in your AWS account. This testing is written in GO, so you need a [GO environment](https://golang.org/doc/install) in your system.

You need to run the following command in the testing folder:
```hcl
  go test -run Test
```



## Feedback
If you come accross a bug or have any feedback, please log it in our [issue tracker](https://github.com/clouddrove/terraform-aws-s3/issues), or feel free to drop us an email at [hello@clouddrove.com](mailto:hello@clouddrove.com).

If you have found it worth your time, go ahead and give us a ★ on [our GitHub](https://github.com/clouddrove/terraform-aws-s3)!

## About us

At [CloudDrove][website], we offer expert guidance, implementation support and services to help organisations accelerate their journey to the cloud. Our services include docker and container orchestration, cloud migration and adoption, infrastructure automation, application modernisation and remediation, and performance engineering.

<p align="center">We are <b> The Cloud Experts!</b></p>
<hr />
<p align="center">We ❤️  <a href="https://github.com/clouddrove">Open Source</a> and you can check out <a href="https://github.com/clouddrove">our other modules</a> to get help with your new Cloud ideas.</p>

  [website]: https://clouddrove.com
  [github]: https://github.com/clouddrove
  [linkedin]: https://cpco.io/linkedin
  [twitter]: https://twitter.com/clouddrove/
  [email]: https://clouddrove.com/contact-us.html
  [terraform_modules]: https://github.com/clouddrove?utf8=%E2%9C%93&q=terraform-&type=&language=