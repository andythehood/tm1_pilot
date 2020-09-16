data "google_dns_managed_zone" "tada_local" {
  project = data.google_project.host_project.project_id
  name    = "tada-local"
}

resource "google_dns_record_set" "puppet_server" {
  project = data.google_project.host_project.project_id
  name    = "${var.puppet_server_name}.${data.google_dns_managed_zone.tada_local.dns_name}"
  type    = "A"
  ttl     = 300

  managed_zone = data.google_dns_managed_zone.tada_local.name
  rrdatas      = [google_compute_instance.puppet_server.network_interface[0].network_ip]
}
resource "google_dns_record_set" "rhel_server" {
  project = data.google_project.host_project.project_id
  name    = "${var.rhel_server_name}.${data.google_dns_managed_zone.tada_local.dns_name}"
  type    = "A"
  ttl     = 300

  #   managed_zone = var.dns_domain_name
  managed_zone = data.google_dns_managed_zone.tada_local.name
  rrdatas      = [google_compute_instance.rhel_server.network_interface[0].network_ip]
}

resource "google_dns_record_set" "win_server" {
  project = data.google_project.host_project.project_id
  name    = "${var.win_server_name}.${data.google_dns_managed_zone.tada_local.dns_name}"
  type    = "A"
  ttl     = 300

  managed_zone = data.google_dns_managed_zone.tada_local.name
  rrdatas      = [google_compute_instance.win_server.network_interface[0].network_ip]
}

resource "google_dns_record_set" "cloudsql_server" {
  project = data.google_project.host_project.project_id
  name    = "${var.cloudsql_server_name}.${data.google_dns_managed_zone.tada_local.dns_name}"
  type    = "A"
  ttl     = 300

  managed_zone = data.google_dns_managed_zone.tada_local.name
  rrdatas      = [google_sql_database_instance.mssql_instance.private_ip_address]
}


data "google_compute_network" "host_default_network" {
  project = data.google_project.host_project.project_id
  name    = "default"
}


resource "google_dns_managed_zone" "tada_local_peering_zone" {
  project     = data.google_project.tm1_pilot_project.project_id
  name        = "tada-local-peer"
  dns_name    = data.google_dns_managed_zone.tada_local.dns_name
  description = "Private DNS peering zone for tada.local"

  visibility = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.tm1_network.id
    }
  }

  peering_config {
    target_network {
      network_url = data.google_compute_network.host_default_network.id
    }
  }
}



