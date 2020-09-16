resource "google_compute_network" "tm1_network" {
  project                 = data.google_project.tm1_pilot_project.project_id
  name                    = var.tm1_network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "tm1_subnetwork" {
  project       = data.google_project.tm1_pilot_project.project_id
  name          = var.tm1_subnetwork_name
  ip_cidr_range = var.tm1_subnet_range
  region        = var.default_region
  network       = google_compute_network.tm1_network.id

}

resource "google_compute_router" "nat_router" {
  project = data.google_project.tm1_pilot_project.project_id
  name    = "nat-router"
  region  = google_compute_subnetwork.tm1_subnetwork.region
  network = google_compute_network.tm1_network.id
}

resource "google_compute_router_nat" "nat_gateway" {
  project = data.google_project.tm1_pilot_project.project_id
  name    = "nat-gateway"
  router  = google_compute_router.nat_router.name
  region  = google_compute_router.nat_router.region

  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES"
}
