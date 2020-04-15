resource "helm_release" "elasticsearch-curator" {
  count      = var.curator_enabled
  name       = var.curator_release_name
  chart      = "elasticsearch-curator"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.curator_namespace
  values     = [data.template_file.curator-values.rendered]
  version    = var.curator_chart_version
  atomic     = true

  lifecycle {
    ignore_changes = [keyring]
  }
}

