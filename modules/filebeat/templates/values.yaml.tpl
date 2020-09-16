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

image: docker.elastic.co/beats/filebeat-oss
filebeatConfig:
  filebeat.yml: |
    setup.template.enabled: false
    setup.ilm.enabled: false
    filebeat.registry.flush: 2s
    filebeat.config:
      modules:
        path: $${path.config}/modules.d/*.yml
        reload.enabled: false
      inputs:
        path: $${path.config}/prospectors.d/*.yml
        reload.enabled: false
    filebeat.inputs:
    - containers.ids:
      - '*'
      processors:
      - add_kubernetes_metadata:
          in_cluster: true
      - drop_event:
          when:
              equals:
                  kubernetes.namespace: ${namespace}
      - drop_fields:
          fields: ["beat.hostname", "beat.name", "beat.version", "input.type", "host.name"]
      type: docker
    http.enabled: false
    http.port: 5066
    output.elasticsearch:
      hosts: ["https://${elasticsearch_endpoint}:${elasticsearch_port}"]
      index: "filebeat-%%{+yyyy.MM.dd}"
    output.file:
      enabled: false
    processors:
    - add_cloud_metadata: null
