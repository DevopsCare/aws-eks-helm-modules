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
  default = "6.4"
}

variable "curator_enabled" {
  default = 1
}

variable "curator_chart_version" {
  default = "1.2.1"
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

variable "kibana_chart_version" {
  default = "1.6.0"
}

variable "kibana_release_name" {
  default = "kibana"
}

variable "kibana_namespace" {
  default = "default"
}

variable "kibana_version" {
  default = "6.4.3"
}

variable "oauth_proxy_address" {
  type    = string
  default = ""
}

variable "selfhosted_kibana_enabled" {
  description = "Enable deploy Kibana to the Kubernetes cluster "
  default     = 1
}

variable "subnet_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

