provider "google" {
  version = "~> 3.30"
}

provider "random" {
}

locals {
  #  parent = var.parent_folder != "" ? "folders/${var.parent_folder}" : "organizations/${var.org_id}"
}

#resource "google_project" "tm1_pilot_project" {
#  name       = var.project_name
#  project_id = var.project_id
#  auto_create_network = false
#  folder_id = data.google_active_folder.pilot_folder.name
#}

data "google_organization" "org" {
  domain = "tada.com.au"
}

data "google_active_folder" "pilot_folder" {
  display_name = "Pilots"
  parent       = data.google_organization.org.name
}

data "google_project" "tm1_pilot_project" {
  project_id = var.tm1_project_id
}

data "google_project" "host_project" {
  project_id = var.host_project_id
}

# Enable Services

resource "google_project_service" "cloud_logging" {
  project = data.google_project.tm1_pilot_project.project_id
  service = "logging.googleapis.com"

  disable_dependent_services = true
}

resource "google_project_service" "service_networking" {
  project = data.google_project.tm1_pilot_project.project_id
  service = "servicenetworking.googleapis.com"

  disable_dependent_services = true
}

