locals {
  admin_password = length(var.admin_password) > 0 ? var.admin_password : random_password.admin_password.result
}

resource "random_password" "admin_password" {
  length      = 16
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  special     = false
}

variable "admin_password" {
  type        = string
  default     = ""
  description = "Will autogenerate random if not set"
  sensitive   = true
}

resource "random_password" "apr1_salt" {
  length      = 8
  min_lower   = 2
  min_upper   = 2
  min_numeric = 2
  special     = true
}

resource "htpasswd_password" "admin_password_hash" {
  password = random_password.admin_password.result
  salt     = random_password.apr1_salt.result
}

resource "kubernetes_secret" "kubernetes-dashboard" {
  depends_on = [var.eks_cluster]
  metadata {
    name      = "cadmium-basic-auth"
    namespace = "kube-system"
  }

  # https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
  data = {
    auth = "admin:${htpasswd_password.admin_password_hash.apr1}"
  }
}
