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

variable "external_dns_additional_settings" {
  default = ""
}

variable "external_dns_chart_version" {
  default = "4.3.1"
}

variable "external_dns_enabled" {
  default = 1
}

variable "external_dns_namespace" {
  default = "kube-system"
}

variable "external_dns_release_name" {
  default = "external-dns"
}

variable "external_dns_txt_owner_id" {
  description = "Specify owner which will be put into TXT record"
  default     = ""
}

variable "irsa_provider_url" {
  type = string
}
