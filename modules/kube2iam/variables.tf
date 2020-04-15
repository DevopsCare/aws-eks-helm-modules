variable "kube2iam_enabled" {
  default = 1
}

variable "kube2iam_release_name" {
  default = "kube2iam"
}

variable "kube2iam_namespace" {
  default = "kube-system"
}

variable "kube2iam_chart_version" {
  default = "2.2.0"
}

variable "kube2iam_additional_settings" {
  default = ""
}

variable "timeout" {
  type    = number
  default = 30
}

variable "kube2iam_base_role_arn" {
  type    = string
  default = null
}

variable "kube2iam_default_role" {
  type    = string
  default = null
}
