# Specify the provider (GCP, AWS, Azure)
provider "google" {
credentials = "${file("leobtest-132e6114466e.json")}"
project = "leobtest-204408"
region = "us-central1"
}
