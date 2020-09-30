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

provider "kubernetes" {
  version = "~> 1.11.1"

  host                   = var.kubernetes_host
  cluster_ca_certificate = base64decode(var.kubernetes_ca_certificate)
  token                  = var.kubernetes_token
  load_config_file       = false
}

provider "helm" {
  version = "~> 1.1.1"

  kubernetes {
    host                   = var.kubernetes_host
    cluster_ca_certificate = base64decode(var.kubernetes_ca_certificate)
    token                  = var.kubernetes_token
    load_config_file       = false
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "kubernetes_namespace" "ui" {
  metadata {
    name = "ui"
  }
}

resource "kubernetes_namespace" "logging" {
  metadata {
    name = "logging"
  }
}

resource "kubernetes_namespace" "cert_manager" {
  metadata {
    name = "cert-manager"
  }
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  aws_region = data.aws_region.current.name
  vpc_name   = "${var.project_prefix}-vpc"

  vpc_tags = {
    Environment = "${var.project_prefix}-infra"
  }

  eks_tags = {
    Name        = "${var.project_prefix}-eks"
    Environment = "${var.project_prefix}-infra"
  }

  route53_tags = {
    Name        = "${var.project_prefix}-dns"
    Environment = "${var.project_prefix}-infra"
  }

  bastion_tags = {
    Name        = "${var.project_prefix}-eks-bastion"
    Environment = "${var.project_prefix}-infra"
  }

  // TODO update from API
  github_meta_hooks = [
    "192.30.252.0/22",
    "185.199.108.0/22",
    "140.82.112.0/20",
  ]

  // https://confluence.atlassian.com/bitbucket/what-are-the-bitbucket-cloud-ip-addresses-i-should-use-to-configure-my-corporate-firewall-343343385.html
  atlassian_inbound = [
    "18.205.93.0/25",
    "18.234.32.128/25",
    "13.52.5.0/25",
  ]
}

