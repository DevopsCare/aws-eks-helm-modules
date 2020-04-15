resource "helm_release" "autoscaler" {
  count      = var.autoscaler_enabled
  name       = var.autoscaler_release_name
  chart      = "cluster-autoscaler"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = var.autoscaler_namespace
  version    = var.autoscaler_chart_version
  timeout    = var.timeout
  atomic     = true

  values = [file("${path.module}/files/values.yaml"),
    var.autoscaler_additional_settings,
  ]

  set {
    name  = "awsRegion"
    value = var.aws_region
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "sslCertPath"
    value = var.autoscaler_ssl_cert_path
  }

  set {
    name  = "image.tag"
    value = var.autoscaler_image_tag
}

  lifecycle {
    ignore_changes = [keyring]
  }
}
