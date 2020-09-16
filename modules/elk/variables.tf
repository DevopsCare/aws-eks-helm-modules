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

variable "aws_region" {
  type = string
}

variable "root_domain" {
  default = "weissr.click"
}

variable "ebs_size" {
  default = 10
}

variable "elasticsearch_port" {
  default = 443
}

variable "elasticsearch_version" {
  default = "7.1"
}

variable "curator_enabled" {
  default = 1
}

variable "curator_chart_version" {
  default = "2.1.5"
}

variable "curator_namespace" {
  default = "logging"
}

variable "curator_release_name" {
  default = "elasticsearch-curator"
}

variable "instance_count" {
  default = 1
}

variable "instance_type" {
  default = "t2.small.elasticsearch"
}

variable "ip_whitelist" {
  description = "List of IP's which will have an access to Kibana"
  type        = list(string)
  default     = []
}

variable "nginx_kibana_chart_version" {
  default = "5.2.0"
}

variable "nginx_kibana_release_name" {
  default = "kibana"
}

variable "nginx_kibana_namespace" {
  default = "monitoring"
}

variable "oauth_proxy_address" {
  type    = string
  default = ""
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

