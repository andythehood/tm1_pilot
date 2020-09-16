

resource "google_compute_global_address" "tm1_network_private_services_ip_range" {

  project = data.google_project.tm1_pilot_project.project_id

  name          = "tm1-network-private-services-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 24
  network       = google_compute_network.tm1_network.id
}

resource "google_service_networking_connection" "tm1_network_vpc_connection" {
  network                 = google_compute_network.tm1_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.tm1_network_private_services_ip_range.name]
}

resource "random_id" "db_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "mssql_instance" {

  project = data.google_project.tm1_pilot_project.project_id

  database_version = "SQLSERVER_2017_STANDARD"
  name             = "private-instance-${random_id.db_name_suffix.hex}"
  root_password    = var.cloudsql_db_root_password
  region           = var.default_region

  depends_on = [google_service_networking_connection.tm1_network_vpc_connection]

  settings {
    tier = "db-custom-2-13312"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.tm1_network.id
    }
  }
}


output "sql_database_config" {
  value = google_sql_database_instance.mssql_instance
}

