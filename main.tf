provider "aws" {
  region = local.region
}

locals {
  region = "ap-south-1"
}

module "dev" {
    source = "./dev"
}

resource "aws_s3_bucket" "dodgyBucket" {
  bucket = "mybucket"
  acl = "authenticated-read"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = "arn"
        sse_algorithm = "aws:kms"
      }
    }
  }
}