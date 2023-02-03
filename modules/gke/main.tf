
# GKE cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project}-gke-${var.env}"
  location = "${var.location}"
  
  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1
  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "node-pool-managed-${var.env}"
  location   = "${var.location}"
  cluster    = google_container_cluster.primary.name
  node_count = var.gke_num_nodes
  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
    labels = {
      env = var.project
    }
    # preemptible  = true
    machine_type = "n1-standard-1"
    disk_size_gb = 50
    tags         = ["gke-node", "${var.project}-gke", "${var.env}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}

# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project}-vpc-${var.env}"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project}-subnet-${var.env}"
  region        = "${var.region}"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}