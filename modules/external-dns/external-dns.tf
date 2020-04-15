resource "helm_release" "external-dns" {
  count      = var.external_dns_enabled
  name       = var.external_dns_release_name
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  namespace  = var.external_dns_namespace
  version    = var.external_dns_chart_version
  atomic     = true

  values = [file("${path.module}/files/values.yaml"),
    var.external_dns_additional_settings,
  ]

  set {
    name  = "aws.region"
    value = var.aws_region
  }

  set {
    name  = "txtOwnerId"
    value = var.external_dns_txt_owner_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}
