resource "helm_release" "prometheus-operator" {
  name       = var.prometheus_operator_release_name
  chart      = "prometheus-operator"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.prometheus_operator_namespace
  version    = var.prometheus_operator_chart_version
  values     = [data.template_file.prometheus-operator-values.rendered]
  atomic     = true

  lifecycle {
    ignore_changes = [keyring]
  }
}
