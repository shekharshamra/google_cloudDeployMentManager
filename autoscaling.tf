resource "google_compute_instance_template" "appserver" {
  name           = "appserver"
  machine_type   = "n1-standard-1"
  can_ip_forward = false

  tags = ["foo", "bar"]

  disk {
    source_image = "image-dockermachine"
  }

  network_interface {
    subnetwork = "ximble-subnet"
  }

  metadata {
    foo = "bar"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}

resource "google_compute_target_pool" "shekhar" {
  name = "shekhar"
}

resource "google_compute_instance_group_manager" "manage1" {
  name = "mamage1"
  zone = "us-central1-f"

  instance_template  = "${google_compute_instance_template.appserver.self_link}"
  target_pools       = ["${google_compute_target_pool.shekhar.self_link}"]
  base_instance_name = "test"
}

resource "google_compute_autoscaler" "test" {
  name   = "scaler"
  zone   = "us-central1-f"
  target = "${google_compute_instance_group_manager.manage1.self_link}"

  autoscaling_policy = {
    max_replicas    = 5
    min_replicas    = 2
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

