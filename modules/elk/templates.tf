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

data "template_file" "curator-values" {
  count    = var.enabled ? 1 : 0
  template = file("${path.module}/templates/curator-values.yaml.tpl")

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.es[0].endpoint}"
    elasticsearch_port     = var.elasticsearch_port
  }
}

data "template_file" "nginx-kibana-values" {
  count    = var.enabled ? 1 : 0
  template = file("${path.module}/templates/nginx-kibana-values.yaml.tpl")

  vars = {
    elasticsearch_endpoint = "https://${aws_elasticsearch_domain.es[0].endpoint}:${var.elasticsearch_port}"
    expose_enabled         = "true"
    oauth_proxy            = var.oauth_proxy_address
  }
}

