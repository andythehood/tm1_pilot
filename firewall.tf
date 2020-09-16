resource "google_compute_firewall" "allow_ssh" {
  project = data.google_project.tm1_pilot_project.project_id

  name    = "allow-ssh-tm1-network"
  network = google_compute_network.tm1_network.id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow_puppet" {
  project = data.google_project.tm1_pilot_project.project_id

  name    = "allow-puppet-tm1-network"
  network = google_compute_network.tm1_network.id

  allow {
    protocol = "tcp"
    ports    = ["8140"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow_rdp" {
  project = data.google_project.tm1_pilot_project.project_id

  name    = "allow-rdp-tm1-network"
  network = google_compute_network.tm1_network.id

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
}
resource "google_compute_firewall" "allow_http" {
  project = data.google_project.tm1_pilot_project.project_id

  name    = "allow-http-tm1-network"
  network = google_compute_network.tm1_network.id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
}

