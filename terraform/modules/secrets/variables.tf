variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
    type = string
    description = "Environnement string"
}

variable "admin_ips" {
  description = "IPs admins List with CIDR format (ex: [\"123.45.67.89/32\", \"98.76.54.32/32\"])"
  type        = list(string)
  sensitive   = true
}

variable "domain_name" {
  description = "Principal domain name for the platform"
  type        = string
  sensitive   = true
}