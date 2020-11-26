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

variable "autoscaler_additional_settings" {
  default = ""
}

variable "autoscaler_chart_version" {
  default = "1.1.0"
}

variable "autoscaler_enabled" {
  default = 1
}

variable "autoscaler_namespace" {
  default = "kube-system"
}

variable "autoscaler_release_name" {
  default = "aws-cluster-autoscaler"
}

variable "aws_region" {
  type = string
}

variable "irsa_provider_url" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "timeout" {
  type    = string
  default = 30
}
