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

variable "nginx_kibana_chart_version" {
  default = "5.1.1"
}

variable "nginx_kibana_release_name" {
  default = "kibana"
}

variable "nginx_kibana_namespace" {
  default = "default"
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

