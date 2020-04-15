variable "autoscaler_additional_settings" {
  default = ""
}

variable "autoscaler_chart_version" {
  default = "7.2.2"
}

variable "autoscaler_image_tag" {
  default = "v1.13.7"
}

variable "autoscaler_enabled" {
  default = 1
}

variable "autoscaler_namespace" {
  default = "kube-system"
}

variable "autoscaler_release_name" {
  default = "aws-cluster-autoscaler"
}

variable "autoscaler_ssl_cert_path" {
  description = "Path to CA crt file. It is different for EKS and KOPS."
  default     = "/etc/ssl/certs/ca-bundle.crt"
}

variable "aws_region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "timeout" {
  type    = string
  default = 30
}
