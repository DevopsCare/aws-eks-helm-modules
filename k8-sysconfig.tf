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
  cluster_name      = var.eks_cluster.cluster_name
  autoscaler_additional_settings = "image: { tag: v1.24.0 }"
  irsa_provider_arn = var.eks_cluster.oidc_provider_arn
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
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  version    = var.metrics_helm_chart_version
  namespace  = "kube-system"
  values     = [file("${path.module}/values/metrics-server.yaml")]
  atomic     = true
}

resource "helm_release" "kubernetes-dashboard" {
  depends_on = [kubernetes_secret.kubernetes-dashboard]
  name       = "kubernetes-dashboard"
  chart      = "kubernetes-dashboard"
  repository = "https://kubernetes.github.io/dashboard"
  version    = var.dashboard_helm_chart_version
  namespace  = kubernetes_namespace.ui.id
  values     = [file("${path.module}/values/dashboard.yaml")]
  atomic     = true
}

module "external-dns" {
  depends_on                = [var.eks_cluster]
  source                    = "./modules/external-dns"
  aws_region                = local.aws_region
  external_dns_txt_owner_id = "${var.project_prefix}-dns-public"
  irsa_provider_url         = local.irsa_provider_url
}

module "prometheus-stack" {
  depends_on             = [var.eks_cluster]
  source                 = "./modules/prometheus-stack"
  domain                 = var.project_fqdn
  admin_password         = local.admin_password
  keycloak_enabled       = var.keycloak_enabled
  keycloak_client_secret = var.keycloak_client_secret
  keycloak_domain        = var.keycloak_domain
  oauth_proxy_address    = var.keycloak_oauth_proxy_address

  prometheus_stack_namespace = kubernetes_namespace.monitoring.id
}

# Allow reading of Prometheus CRDs by Dashboard
resource "kubernetes_cluster_role" "kubernetes-dashboard-prometheus" {
  metadata {
    name = "kubernetes-dashboard-prometheus"
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list"]
  }

  rule {
    api_groups = ["apiextensions.k8s.io"]
    resources  = ["customresourcedefinitions"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["monitoring.coreos.com"]
    resources  = ["podmonitors", "prometheuses", "prometheusrules", "servicemonitors"]
    verbs      = ["get", "list"]
  }
}

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard-prometheus" {
  metadata {
    name = "kubernetes-dashboard-prometheus"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.kubernetes-dashboard-prometheus.id
  }
  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard"
    namespace = "ui"
  }
}
