variable "DEMOROLE_POLICY_ARN" {
  description = "provides ARN for policy used as PermissionBoundary for the demouser"
}

variable "DEMOROLE_ROLE_ARN" {
  description = "provide ARN for the role demouser"
}

variable "ROLE_NAME" {
  description = "role name used in creation AWS auth and AWS secrets engine roles"
}

variable "ALLOWED_ARN_ROLE_LOGIN" {
  description = "ARN of the role that is allowed to login to AWS auth method"
}

variable "INFERRED_AWS_REGION" {
  description = "region when inffering EC2 auth via IAM role"
}

variable "BOUND_VPC_IDS" {
  description = "ID of VPC that is allowed to login to AWS auth method"
}