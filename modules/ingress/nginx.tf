resource "helm_release" "ingress" {
  name       = var.ingress_release_name
  chart      = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.ingress_namespace
  version    = var.nginx_chart_version
  atomic     = true

  values = [file("${path.root}/values/nginx.yaml")]

  lifecycle {
    ignore_changes = [keyring]
  }
}
