data "helm_repository" "coreos" {
  name = "coreos"
  url  = "https://s3-eu-west-1.amazonaws.com/coreos-charts/stable/"
}

module "autoscaler" {
  source       = "./modules/autoscaler"
  aws_region   = local.aws_region
  cluster_name = var.cluster_name
}

resource "helm_release" "overprovisioner" {
  name      = "overprovisioner"
  chart     = "stable/cluster-overprovisioner"
  namespace = "kube-system"
  values    = [file("${path.module}/values/overprovisioner.yaml")]

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "helm_release" "metrics-server" {
  name      = "metrics-server"
  chart     = "stable/metrics-server"
  namespace = "kube-system"

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

resource "helm_release" "kubernetes-dashboard" {
  name      = "kubernetes-dashboard"
  chart     = "stable/kubernetes-dashboard"
  namespace = "kube-system"
  values    = [file("${path.module}/values/dashboard.yaml")]

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  lifecycle {
    ignore_changes = [keyring]
  }
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
}

