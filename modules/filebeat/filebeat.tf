resource "helm_release" "filebeat" {
  name       = var.release_name
  chart      = "filebeat"
  repository = "https://helm.elastic.co"
  namespace  = var.filebeat_namespace
  values     = [data.template_file.values.rendered]
  version    = var.filebeat_chart_version
  atomic     = true

  lifecycle {
    ignore_changes = [keyring]
  }
}
