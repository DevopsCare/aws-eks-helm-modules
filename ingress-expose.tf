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

resource "helm_release" "ingress" {
  depends_on = [var.eks_cluster]
  name       = "ingress-nginx"
  chart      = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  version    = var.nginx_ingress_helm_chart_version
  namespace  = "kube-system"
  atomic     = true

  values = [templatefile("${path.module}/templates/nginx.yaml.tmpl", {
    additional_annotations = var.nginx_ingress_additional_annotations
  })]

  set {
    name = "controller.config.whitelist-source-range"
    value = join(
      "\\,",
      concat(
        var.ip_whitelist,
        var.whitelist_github_hooks ? data.github_ip_ranges.current.hooks_ipv4 : [],
        var.whitelist_atlassian_outgoing ? local.atlassian_outgoing : [],
        var.vpc.nat_public_ips,
      ),
    )
  }

  set {
    name = "controller.service.loadBalancerSourceRanges"
    value = "{${join(
      ",",
      concat(
        var.ip_whitelist,
        var.whitelist_github_hooks ? data.github_ip_ranges.current.hooks_ipv4 : [],
        var.whitelist_atlassian_outgoing ? local.atlassian_outgoing : [],
        formatlist("%s/32", var.vpc.nat_public_ips),
      ),
    )}}"
  }
}

resource "helm_release" "expose-default" {
  depends_on = [var.eks_cluster]
  name       = "expose-default"
  chart      = "exposecontroller"
  repository = "https://jenkins-x-charts.github.io/v2/"
  namespace  = "default"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }
}

resource "helm_release" "expose-ui" {
  depends_on = [kubernetes_secret.kubernetes-dashboard]
  name       = "expose-default"
  chart      = "exposecontroller"
  repository = "https://jenkins-x-charts.github.io/v2/"
  namespace  = "ui"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }
}

resource "helm_release" "expose-monitoring" {
  depends_on = [var.eks_cluster]
  name       = "expose-monitoring"
  chart      = "exposecontroller"
  repository = "https://jenkins-x-charts.github.io/v2/"
  namespace  = "monitoring"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }
}

resource "helm_release" "expose-logging" {
  depends_on = [var.eks_cluster]
  name       = "expose-default"
  chart      = "exposecontroller"
  repository = "https://jenkins-x-charts.github.io/v2/"
  namespace  = "logging"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }
}
