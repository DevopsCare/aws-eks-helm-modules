
#
# Copyright (c) 2020 Risk Focus Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#

resources:
  limits:
   cpu: 50m
   memory: 64Mi
  requests:
   cpu: 30m
   memory: 32Mi

cronjob:
  successfulJobsHistoryLimit: "2"
  concurrencyPolicy: "Forbid"

configMaps:
  action_file_yml: |-
    ---
    actions:
      1:
        action: delete_indices
        description: Delete indices with %Y.%m.%d in the name where that date is older than 10 days
        options:
          ignore_empty_list: True
        filters:
        - filtertype: age
          source: creation_date
          timestring: '%Y.%m.%d'
          direction: older
          unit: days
          unit_count: 10
  config_yml: |-
    ---
    client:
      hosts:
        - ${elasticsearch_endpoint}
      port: ${elasticsearch_port}
      use_ssl: True
      timeout: 30