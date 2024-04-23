provider "vault" {
  add_address_to_env = true
  skip_child_token   = true
}

# Enable AWS auth method
resource "vault_auth_backend" "aws" {
  type = "aws"
}

# Enable AWS secrets engine
resource "vault_aws_secret_backend" "aws" {
}

# AWS auth method roles start here

# AWS auth EC2 type using PKCS7 document provided by the metadata to log in
# Only EC2 instances from local VPC can log in via this role.
resource "vault_aws_auth_backend_role" "aws_ec2_type_auth" {
  backend              = vault_auth_backend.aws.path
  role                 = "${var.ROLE_NAME}_ec2_type"
  auth_type            = "ec2"
  bound_vpc_ids        = ["${var.BOUND_VPC_IDS}"]
  inferred_entity_type = "ec2_instance"
  token_ttl            = 60
  token_max_ttl        = 120
  token_policies       = ["default"]
}


# role name matches the role of the instance profile of the EC2 instance. No "role=" parameter should be provided via "vault login -method=aws" command.
#resource "vault_aws_auth_backend_role" "aws_iam_type_auth" {
#  backend              = vault_auth_backend.aws.path
#  role                 = var.ROLE_NAME
#  auth_type            = "iam"
#  bound_iam_role_arns  = ["${var.ALLOWED_ARN_ROLE_LOGIN}"]
#  token_ttl            = 60
#  token_max_ttl        = 120
#  token_policies       = ["default"]
#}

# Configuration for AWS secrets engine starts here
resource "vault_aws_secret_backend_role" "role" {
  backend                  = vault_aws_secret_backend.aws.path
  name                     = "demo_aws_secrets_role"
  credential_type          = "iam_user"
  permissions_boundary_arn = var.DEMOROLE_POLICY_ARN
  policy_document          = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOT
}

resource "vault_aws_secret_backend_role" "role_assume" {
  backend         = vault_aws_secret_backend.aws.path
  name            = "demo_aws_secrets_role_assumed_role"
  default_sts_ttl = 900
  credential_type = "assumed_role"
  role_arns       = ["${var.DEMOROLE_ROLE_ARN}"]
}

#Importing vault root token and recovery key into K8S secret
resource "kubernetes_secret" "vault_root_creds" {
  metadata {
    name      = "vault-root-creds"
    namespace = "vault"
  }

  data = {
    root_token   = file("~/.vault-token")
    recovery_key = file("~/.vault-recovery-key")
  }

  type                           = "generic"
  wait_for_service_account_token = false
}

#Creating a role for demo-sa pod in AWS auth
resource "vault_aws_auth_backend_role" "demo_sa_role" {
  backend                  = vault_auth_backend.aws.path
  role                     = var.ROLE_NAME
  auth_type                = "iam"
  bound_iam_principal_arns = [var.ALLOWED_ARN_ROLE_LOGIN] # Example: arn:aws:iam::123361688033:role/consume-pod-role-bright-halibut
  token_ttl                = 60
  token_max_ttl            = 120
  token_policies           = [vault_policy.aws_secrets.name]
}

# Policy allowing access to AWS secrets engine for the demo_sa_role role
resource "vault_policy" "aws_secrets" {
  name = "aws-secrets"

  policy = <<EOT
path "aws/creds/*" {
  capabilities = ["update","create","read"]
}
EOT
}