module "cert-manager" {
  source     = "./modules/cert-manager"
  aws_region = local.aws_region
  email      = var.letsencrypt-email
  kubeconfig = "kubeconfig_${var.cluster_name}"
}

