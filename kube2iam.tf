module "kube2iam" {
  source        = "./modules/kube2iam"

  kube2iam_enabled = var.kube2iam_enabled

  kube2iam_base_role_arn = var.kube2iam_base_role_arn
  kube2iam_default_role  = var.kube2iam_default_role
}
