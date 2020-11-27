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

module "elk" {
  depends_on          = [var.eks_cluster]
  source              = "./modules/elk"
  aws_region          = local.aws_region
  root_domain         = var.project_prefix
  subnet_ids          = [var.vpc.private_subnets[0]]
  vpc_id              = var.vpc.vpc_id
  oauth_proxy_address = var.keycloak_enabled ? var.keycloak_oauth_proxy_address : ""

  ip_whitelist   = ["10.0.0.0/8"]
  instance_count = "2"
  ebs_size       = "35"

  curator_namespace = kubernetes_namespace.logging.id
  nginx_namespace   = kubernetes_namespace.logging.id
}

module "filebeat" {
  depends_on             = [var.eks_cluster]
  source                 = "./modules/filebeat"
  elasticsearch_endpoint = module.elk.elasticsearch_endpoint
  filebeat_namespace     = kubernetes_namespace.logging.id
}

