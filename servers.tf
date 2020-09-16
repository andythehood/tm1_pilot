
data "template_file" "install_puppet_server" {
  template = file("${path.module}/files/install-puppet-server.sh")
}

data "template_file" "install_puppet_agent_rhel" {
  template = file("${path.module}/files/install-puppet-agent-rhel.sh")
  vars = {
    tpl_PUPPET_SERVER = "${var.puppet_server_name}.${var.dns_domain_name}"
  }
}

data "template_file" "install_puppet_agent_windows" {
  template = file("${path.module}/files/install-puppet-agent-windows.ps1")
  vars = {
    tpl_PUPPET_SERVER = "${var.puppet_server_name}.${var.dns_domain_name}"
  }
}

resource "google_compute_instance" "puppet_server" {
  project                   = data.google_project.tm1_pilot_project.project_id
  name                      = var.puppet_server_name
  hostname                  = "${var.puppet_server_name}.${var.dns_domain_name}"
  machine_type              = "n2-custom-2-10240"
  zone                      = "${var.default_region}-a"
  allow_stopping_for_update = true
  min_cpu_platform          = "Intel Cascade Lake"

  tags = ["${var.puppet_server_name}"]

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tm1_subnetwork.id
    # access_config {
    #   // Ephemeral IP
    # }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = data.template_file.install_puppet_server.rendered

  service_account {
    scopes = ["userinfo-email", "cloud-platform"]
  }
}

resource "google_compute_instance" "rhel_server" {
  project                   = data.google_project.tm1_pilot_project.project_id
  name                      = var.rhel_server_name
  hostname                  = "${var.rhel_server_name}.${var.dns_domain_name}"
  machine_type              = "n2-custom-2-10240"
  zone                      = "${var.default_region}-a"
  allow_stopping_for_update = true
  min_cpu_platform          = "Intel Cascade Lake"

  tags = ["${var.rhel_server_name}"]

  boot_disk {
    initialize_params {
      image = "rhel-cloud/rhel-8"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tm1_subnetwork.id
    # access_config {
    #   // Ephemeral IP
    # }
  }
  metadata_startup_script = data.template_file.install_puppet_agent_rhel.rendered

  service_account {
    scopes = ["userinfo-email", "cloud-platform"]
  }
}

output "puppet-server-config" {
  value = google_compute_instance.puppet_server
}

resource "google_compute_instance" "win_server" {
  project                   = data.google_project.tm1_pilot_project.project_id
  name                      = var.win_server_name
  hostname                  = "${var.win_server_name}.${var.dns_domain_name}"
  machine_type              = "n2-standard-2"
  zone                      = "${var.default_region}-a"
  allow_stopping_for_update = true
  min_cpu_platform          = "Intel Cascade Lake"

  tags = ["${var.win_server_name}"]

  boot_disk {
    initialize_params {
      image = "windows-cloud/windows-server-2019-dc-v20200813"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.tm1_subnetwork.id
    access_config {
      // Ephemeral IP
    }
  }

  # Windows password: wD)0-pFLaP7lMDQ
  metadata = {
    windows-startup-script-ps1 = data.template_file.install_puppet_agent_windows.rendered
  }

  service_account {
    scopes = ["userinfo-email", "cloud-platform"]
  }
}

