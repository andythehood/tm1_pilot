

# variable "billing_account" {
#   description = "The ID of the billing account to associate projects with."
#   type        = string
# }


variable "gcp_org_name" {
  description = "GCP Organization Name"
  type        = string
}

variable "tm1_project_id" {
  description = "TM1 Project Id"
  type        = string
}
variable "host_project_id" {
  description = "Host Project Id"
  type        = string
}
# variable "project_name" {
#   description = "GCP Project Name"
#   type        = string
# }

variable "default_region" {
  description = "Default region to create resources where applicable."
  type        = string
  default     = "australia-southeast1"
}

variable "tm1_network_name" {
  description = "Name of the VPC for TM1"
  type        = string
}
variable "tm1_subnetwork_name" {
  description = "Name of the VPC Subnet for TM1"
  type        = string
}

variable "tm1_subnet_range" {
  description = "The subnetwork to which the TM1 resources will be connected (in CIDR range 0.0.0.0/0)"
  type        = string
}

variable "puppet_server_name" {
  description = "Hostname of the Puppet Server (Master)"
  type        = string
}
variable "rhel_server_name" {
  description = "Hostname of the RHEL Server"
  type        = string
}
variable "win_server_name" {
  description = "Hostname of the Windows Server"
  type        = string
}
variable "cloudsql_server_name" {
  description = "DNS Hostname of the CloudSQL Server instance"
  type        = string
}


variable "dns_domain_name" {
  description = "DNS Domain name"
  type        = string
}

variable "cloudsql_db_root_password" {
  description = "CloudSQL DB Root Password"
  type        = string
}
