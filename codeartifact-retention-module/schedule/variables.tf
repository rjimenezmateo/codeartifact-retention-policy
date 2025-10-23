variable "repository_arn" {
  type = string
}

variable "days_to_retain" {
  type = number
}

variable "lambda_arn" {
  type = string
}

variable "rule_name_prefix" {
  type = string
  description = "Prefix used to name and identify EventBridge rules created by this module."
}