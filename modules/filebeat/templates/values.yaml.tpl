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
