variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

variable "env" {

}

variable "project" {

}

variable "location" {
    default     = "us-central1-a"
}

variable "region" {
    default = "us-central"
}