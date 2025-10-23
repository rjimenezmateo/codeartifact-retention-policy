variable "repositories" {
  type = list(object({
    repository_arn = string
    days_to_retain = number
  }))
}

variable "keep_latest" {
  type = bool
  description = "Controls if the latest published package version should be preserved despite the retention policy"
  default = true
}

variable "rule_name_prefix" {
  type = string
  description = "Prefix used to name and identify EventBridge rules created by this module."
  default = "codeartifact-retention"
}