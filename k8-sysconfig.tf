/*
* Copyright (c) 2020 Risk Focus Inc.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*     http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

module "autoscaler" {
  depends_on        = [var.eks_cluster]
  source            = "./modules/autoscaler"
  aws_region        = local.aws_region
  cluster_name      = var.eks_cluster.cluster_id
  irsa_provider_url = local.irsa_provider_url
}

resource "helm_release" "overprovisioner" {
  depends_on = [var.eks_cluster]
  name       = "overprovisioner"
  chart      = "cluster-overprovisioner"
  repository = "https://charts.helm.sh/stable"
  namespace  = "kube-system"
  values     = [file("${path.module}/values/overprovisioner.yaml")]
  atomic     = true
}

resource "helm_release" "metrics-server" {
  depends_on = [var.eks_cluster]
  name       = "metrics-server"
  chart      = "metrics-server"
  repository = "https://charts.helm.sh/stable"
  namespace  = "kube-system"
  atomic     = true

  values = [
    file("${path.module}/values/metrics-server.yaml"),
  ]
}

resource "kubernetes_secret" "kubernetes-dashboard" {
  depends_on = [var.eks_cluster]
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

  depends_on = [
    kubernetes_secret.kubernetes-dashboard
  ]
}

module "external-dns" {
  depends_on                = [var.eks_cluster]
  source                    = "./modules/external-dns"
  aws_region                = local.aws_region
  external_dns_txt_owner_id = "${var.project_prefix}-dns-public"
  irsa_provider_url         = local.irsa_provider_url
}

module "prometheus-operator" {
  depends_on             = [var.eks_cluster]
  source                 = "./modules/prometheus-operator"
  domain                 = var.project_fqdn
  admin_password         = local.admin_password
  keycloak_enabled       = var.keycloak_enabled
  keycloak_client_secret = var.keycloak_client_secret
  keycloak_domain        = var.keycloak_domain
  oauth_proxy_address    = var.keycloak_oauth_proxy_address

  prometheus_operator_namespace = kubernetes_namespace.monitoring.id
}

