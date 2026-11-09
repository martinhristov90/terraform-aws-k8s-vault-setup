variable "DEMOROLE_POLICY_ARN" {
  type        = string
  description = "ARN of the IAM policy used as permissions boundary for the demo IAM user"

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::(aws|[0-9]{12}):policy/.+$", var.DEMOROLE_POLICY_ARN))
    error_message = "DEMOROLE_POLICY_ARN must be an IAM policy ARN, e.g. arn:aws:iam::123456789012:policy/name."
  }
}

variable "DEMOROLE_ROLE_ARN" {
  type        = string
  description = "ARN of the IAM role that Vault assumes for the assumed_role credential type"

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:role/.+$", var.DEMOROLE_ROLE_ARN))
    error_message = "DEMOROLE_ROLE_ARN must be an IAM role ARN, e.g. arn:aws:iam::123456789012:role/name."
  }
}

variable "ROLE_NAME" {
  type        = string
  description = "Role name used in the creation of AWS auth and AWS secrets engine roles"

  validation {
    condition     = length(trimspace(var.ROLE_NAME)) > 0
    error_message = "ROLE_NAME must not be empty."
  }
}

variable "ALLOWED_ARN_ROLE_LOGIN" {
  type        = string
  description = "ARN of the IAM principal (role or user) that is allowed to log in to the AWS auth method"

  validation {
    condition     = can(regex("^arn:aws[a-z-]*:iam::[0-9]{12}:(role|user)/.+$", var.ALLOWED_ARN_ROLE_LOGIN))
    error_message = "ALLOWED_ARN_ROLE_LOGIN must be an IAM role or user ARN, e.g. arn:aws:iam::123456789012:role/name."
  }
}

variable "INFERRED_AWS_REGION" {
  type        = string
  description = "AWS region used when inferring EC2 auth via an IAM role (currently not referenced by any resource)"

  validation {
    condition     = can(regex("^[a-z]{2}(-[a-z]+)+-[0-9]+$", var.INFERRED_AWS_REGION))
    error_message = "INFERRED_AWS_REGION must be an AWS region name, e.g. us-east-1."
  }
}

variable "BOUND_VPC_IDS" {
  type        = string
  description = "ID of the VPC whose EC2 instances are allowed to log in to the AWS auth method"

  validation {
    condition     = can(regex("^vpc-[0-9a-f]{8}([0-9a-f]{9})?$", var.BOUND_VPC_IDS))
    error_message = "BOUND_VPC_IDS must be a VPC ID, e.g. vpc-0123456789abcdef0."
  }
}
