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

variable "certmanager_chart_version" {
  default = "v1.0.0"
}

variable "certmanager_namespace" {
  default = "cert-manager"
}

variable "certmanager_release_name" {
  default = "cert-manager"
}

variable "email" {
  description = "Email will be used for letsencrypt registration"
  type        = string
}

variable "kubeconfig" {
  type = string
}

variable "staging" {
  default = true
}
