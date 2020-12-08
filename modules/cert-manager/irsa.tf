module "iam_assumable_role_admin" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.6.0"
  create_role                   = true
  role_name                     = "eks-${var.certmanager_release_name}"
  provider_url                  = var.irsa_provider_url
  role_policy_arns              = ["arn:aws:iam::aws:policy/AmazonRoute53FullAccess"]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.certmanager_namespace}:${var.certmanager_release_name}"]
}
