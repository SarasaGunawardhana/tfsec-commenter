############
# IAM users
############

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

module "iam_user1" {
  source = "terraform-aws-modules/iam/aws//modules/iam-user"

  name = "sarasa"
  
  force_destroy = true
  password_reset_required = true
  create_iam_user_login_profile = true
  create_iam_access_key         = false
}


module "Admins" {
  source = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"

  name = "Admins"

  create_group = true
  group_users = [
    module.iam_user1.iam_user_name
  ]
  custom_group_policy_arns = [
    "arn:aws:iam::aws:policy/AdministratorAccess",
  ]
}