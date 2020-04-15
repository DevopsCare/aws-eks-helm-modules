resource "helm_release" "kube2iam" {
  count      = var.kube2iam_enabled
  name       = var.kube2iam_release_name
  chart      = "kube2iam"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.kube2iam_namespace
  version    = var.kube2iam_chart_version
  timeout    = var.timeout
  atomic     = true

  values = [file("${path.module}/files/values.yaml"),
    var.kube2iam_additional_settings,
  ]

  set {
    name  = "extraArgs.base-role-arn"
    value = var.kube2iam_base_role_arn
  }

  set {
    name  = "extraArgs.default-role"
    value = var.kube2iam_default_role
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}
