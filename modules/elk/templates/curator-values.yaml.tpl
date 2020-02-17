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