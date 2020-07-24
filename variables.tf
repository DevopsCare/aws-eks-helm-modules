variable "project_prefix" {
}

variable "project_fqdn" {
}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

variable "dashboard_helm_chart_version" {
  type    = string
  default = "2.3.0"
}

# default: admin bT2s3yNtK8oQPMeR
variable "dashboard_basic_auth" {
  type    = string
  default = "admin:$apr1$FmDTIlPt$vaQ6Fi9vTNFxJXvYyDc6o0"
}

variable "nginx_ingress_helm_chart_version" {
  type    = string
  default = "1.36.2"
}

variable "nginx_ingress_additional_annotations" {
  type    = map
  default = {}
}

variable "letsencrypt-email" {
  description = "Email for registration in Letsencrypt"
  default     = "acme@example.com"
}

variable "extra_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

// Keycloak
variable "keycloak_enabled" {
  default = false
}

variable "keycloak_client_secret" {
  type    = string
  default = ""
}

variable "keycloak_domain" {
  type    = string
  default = ""
}

variable "keycloak_oauth_proxy_address" {
  type    = string
  default = ""
}

variable "tiller_version" {
  default = "v2.14.3"
}

variable "vpc" {
}

variable "eks_cluster" {
}

variable "cluster_name" {
}

variable "kube2iam_base_role_arn" {
  type    = string
  default = "None"
}

variable "kube2iam_default_role" {
  type    = string
  default = "None"
}

variable "kube2iam_enabled" {
  default = 0
}

variable "kubernetes_host" {
}

variable "kubernetes_ca_certificate" {
}

variable "kubernetes_token" {
}
