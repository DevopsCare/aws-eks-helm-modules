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

data "aws_caller_identity" "current" {}

module "sg_es" {
  source  = "terraform-aws-modules/security-group/aws//modules/https-443"
  version = "~>3.17.0"
  create  = var.enabled

  name                   = "elasticsearch-${var.root_domain}"
  vpc_id                 = var.vpc_id
  ingress_cidr_blocks    = var.ip_whitelist
  auto_ingress_with_self = []
  auto_egress_rules      = []
}

resource "aws_iam_service_linked_role" "es" {
  aws_service_name = "es.amazonaws.com"
}

resource "aws_elasticsearch_domain" "es" {
  count                 = var.enabled ? 1 : 0
  domain_name           = var.root_domain
  elasticsearch_version = var.elasticsearch_version

  cluster_config {
    instance_count = var.instance_count
    instance_type  = var.instance_type
  }

  vpc_options {
    subnet_ids         = var.subnet_ids
    security_group_ids = [module.sg_es.this_security_group_id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.ebs_size
  }

  access_policies = <<-CONFIG
  {
      "Version": "2012-10-17",
      "Statement": [
          {
              "Action": "es:*",
              "Principal": "*",
              "Effect": "Allow",
              "Resource": "arn:aws:es:${var.aws_region}:${data.aws_caller_identity.current.account_id}:domain/${var.root_domain}/*"
          }
      ]
  }
CONFIG


  tags = {
    Domain = var.root_domain
  }

  depends_on = [aws_iam_service_linked_role.es]
}

