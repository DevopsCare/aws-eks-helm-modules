data "helm_repository" "jx" {
  name = "jx"
  url  = "http://chartmuseum.jenkins-x.io"
}

resource "helm_release" "ingress" {
  name       = "nginx-ingress"
  chart      = "nginx-ingress"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  version    = var.nginx_ingress_helm_chart_version
  namespace  = "kube-system"
  values     = [file("${path.module}/values/nginx.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  set {
    name = "controller.config.whitelist-source-range"
    value = join(
      "\\,",
      concat(
        var.ip_whitelist,
        local.github_meta_hooks,
        local.atlassian_inbound,
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
        local.github_meta_hooks,
        local.atlassian_inbound,
        formatlist("%s/32", var.vpc.nat_public_ips),
      ),
    )}}"
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "helm_release" "expose-default" {
  name       = "expose-default"
  chart      = "exposecontroller"
  repository = "http://chartmuseum.jenkins-x.io"
  namespace  = "default"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "helm_release" "expose-monitoring" {
  name       = "expose-monitoring"
  chart      = "exposecontroller"
  repository = "http://chartmuseum.jenkins-x.io"
  namespace  = "monitoring"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}

resource "helm_release" "expose-logging" {
  name       = "expose-default"
  chart      = "exposecontroller"
  repository = "http://chartmuseum.jenkins-x.io"
  namespace  = "logging"
  values     = [file("${path.module}/values/expose.yaml")]
  atomic     = true

  set {
    name  = "dummy.depends_on"
    value = var.eks_cluster.cluster_id
  }

  set {
    name  = "config.domain"
    value = var.project_fqdn
  }

  lifecycle {
    ignore_changes = [keyring]
  }
}
