provider "vault" {
  add_address_to_env = true
  skip_child_token   = true
}

# Enable AWS auth method, needed permissions to AWS API are provided via EC2 instance profile
resource "vault_auth_backend" "aws" {
  type = "aws"
}

# Enable AWS secrets engine, needed permissions to AWS API are provided via EC2 instance profile
resource "vault_aws_secret_backend" "aws" {
}