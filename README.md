<p align="center"><img src="https://i.imgur.com/x5kv2Vt.png" /></p>

> Terraform module to create S3 bucket on AWS


<p align="center">
    <a href="LICENSE.md">
      <img src="https://img.shields.io/badge/license-MIT-brightgreen.svg?style=flat-square" alt="Software License">
    </a>
    <a href="https://www.paypal.me/anmolnagpal">
      <img src="https://img.shields.io/badge/PayPal-Buy%20Me%20A%20BEER-blue.svg?style=flat-squares" alt="Donate">
    </a>
  </p>
</p>

Example of Bucket with only private access
------------------------------------------

```hcl
module "s3_bucket" {
  source                 = "git::https://github.com/clouddrove/terraform-aws-s3.git"
  name                   = "devopswhizz"
  region                 = "eu-west-2"
  organization           = "dt"
  environment            = "live"
  versioning             = true
  acl                    = "private"
  }
```



## 👬 Contribution
- Open pull request with improvements
- Discuss ideas in issues
