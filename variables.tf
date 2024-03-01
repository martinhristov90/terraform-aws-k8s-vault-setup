variable "demorole_arn" {
    description="provides ARN for the demouser"
}

variable "role_name" {
    description="role name used in creation AWS auth and AWS secrets engine roles"
}

variable "allowed_role_arn_login" {
    description="ARN of the role that is allowed to login to AWS auth method"
}

variable "inferred_aws_region"{
    description="region when inffering EC2 auth via IAM role"
}

variable "bound_vpc_ids" {
    description="ID of VPC that is allowed to login to AWS auth method"
}