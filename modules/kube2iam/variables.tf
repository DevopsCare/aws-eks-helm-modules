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

variable "kube2iam_enabled" {
  default = 1
}

variable "kube2iam_release_name" {
  default = "kube2iam"
}

variable "kube2iam_namespace" {
  default = "kube-system"
}

variable "kube2iam_chart_version" {
  default = "2.2.0"
}

variable "kube2iam_additional_settings" {
  default = ""
}

variable "timeout" {
  type    = number
  default = 30
}

variable "kube2iam_base_role_arn" {
  type    = string
  default = null
}

variable "kube2iam_default_role" {
  type    = string
  default = null
}
