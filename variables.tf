variable "project_prefix" {
}

variable "project_fqdn" {
}

variable "ip_whitelist" {
  type    = list(string)
  default = []
}

variable "config_output_path" {
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
