resource "helm_release" "nginx-kibana" {
  name       = var.nginx_kibana_release_name
  chart      = "nginx"
  repository = "https://charts.bitnami.com/bitnami"
  namespace  = var.nginx_kibana_namespace
  values     = [
    data.template_file.nginx-kibana-values.rendered,
  ]
  version    = var.nginx_kibana_chart_version

  lifecycle {
    ignore_changes = [
      keyring,
    ]
  }
}

