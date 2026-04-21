# S3 Filesystem with Terraform (AWS)

This project provisions an AWS infrastructure using Terraform that includes:

* VPC with public and private subnets
* Security Group configured for NFS access
* S3 Bucket with versioning enabled
* S3Files File System (integrated with S3)
* Access Point, Mount Targets, and Synchronization Rules

The setup is modular and uses reusable Terraform modules.

## 🚀 Features

* Fully automated AWS infrastructure using Terraform
* Modular approach for VPC, Subnets, and Security Groups
* S3 bucket with versioning and lifecycle support
* S3Files integration with:

  * File system
  * Access point
  * Mount targets
  * Sync configuration
* POSIX user and root directory configuration
* Data import and expiration rules

---

## ⚙️ Prerequisites

Make sure you have:

* Terraform >= 1.3
* AWS CLI configured (`aws configure`)
* Proper IAM permissions to create:

  * S3
  * VPC
  * IAM roles
  * S3Files resources

---

## 🛠️ Usage

### 1. Initialize Terraform

```bash
terraform init
```

### 2. Validate Configuration

```bash
terraform validate
```

### 3. Plan Infrastructure

```bash
terraform plan
```

### 4. Apply Changes

```bash
terraform apply
```

---

## 📦 Modules Used

* VPC Module
* Subnet Module
* Security Group Module
* Custom S3 + S3Files Module

---

## 🔑 Key Configuration

### Provider

```hcl
provider "aws" {
  region = local.region
}
```

---

### Local Values

```hcl
locals {
  name        = "app"
  environment = "test"
  region      = "us-east-1"
}
```

---

### S3 + S3Files Module

```hcl
module "s3_bucket" {
  source = "./../../"

  name        = "s3filesytemexample"
  environment = local.environment

  enable_s3files = true

  versioning    = true
  force_destroy = true

  prefix = "/"

  posix_user = {
    uid = 1000
    gid = 1000
  }

  subnet_id       = module.subnets.public_subnet_id
  security_groups = [module.security_group.security_group_id]
}
```

---

## 📊 Outputs

After deployment, you will get:

* S3Files File System ID & ARN
* Access Point details
* Mount Target details
* Sync configuration version

---

## 🔐 Security

* Security Group allows NFS (port 2049) within VPC only
* IAM roles follow least privilege principle
* Optional KMS encryption support

---

## 📌 Notes

* `enable_s3files = true` is required to enable S3Files resources
* Ensure subnets are correctly configured for mount targets
* If using multiple subnets, mount targets will be created in each

---

## ❗ Troubleshooting

* If Terraform fails with dependency issues, re-run:

  ```bash
  terraform apply
  ```
* Ensure AWS provider supports S3Files resources
* Check IAM permissions if role creation fails

---

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

---

## 📖 Conclusion

This setup provides a scalable and modular way to integrate S3 with file system-like access using Terraform. It is suitable for applications requiring shared storage with S3 backend.

---
