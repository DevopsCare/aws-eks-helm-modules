module "autoscaler" {
  source       = "./modules/autoscaler"
  aws_region   = local.aws_region
  cluster_name = var.cluster_name
}

resource "helm_release" "overprovisioner" {
  name       = "overprovisioner"
  chart      = "cluster-overprovisioner"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = "kube-system"
  values     = [file("${path.module}/values/overprovisioner.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  chart      = "metrics-server"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  namespace  = "kube-system"
  atomic     = true

  values = [
    file("${path.module}/values/metrics-server.yaml"),
  ]

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "kubernetes_secret" "kubernetes-dashboard" {
  metadata {
    name      = "kubernetes-dashboard-auth"
    namespace = kubernetes_namespace.ui.id
  }

  # https://kubernetes.github.io/ingress-nginx/examples/auth/basic/
  data = {
    auth = var.dashboard_basic_auth
  }
}

resource "helm_release" "kubernetes-dashboard" {
  name       = "kubernetes-dashboard"
  chart      = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard/"
  version    = var.dashboard_helm_chart_version
  namespace  = kubernetes_namespace.ui.id
  values     = [file("${path.module}/values/dashboard.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }

  depends_on = [
    kubernetes_secret.kubernetes-dashboard
  ]
}

module "external-dns" {
  source                    = "./modules/external-dns"
  aws_region                = local.aws_region
  external_dns_txt_owner_id = "${var.project_prefix}-dns-public"
}

module "prometheus-operator" {
  source                 = "./modules/prometheus-operator"
  domain                 = var.project_fqdn
  keycloak_enabled       = var.keycloak_enabled
  keycloak_client_secret = var.keycloak_client_secret
  keycloak_domain        = var.keycloak_domain
  oauth_proxy_address    = var.keycloak_oauth_proxy_address

  prometheus_operator_namespace = kubernetes_namespace.monitoring.id
}

