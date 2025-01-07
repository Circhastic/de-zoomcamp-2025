terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.15.0"
    }
  }
}

provider "google" {
  credentials = "./keys/creds.json" # you can also use GOOGLE_APPLICATION_CREDENTIALS env variable
  project = "terraform-demo-447113"
  region  = "asia-southeast2"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "terraform-demo-447113-terra-bucket" # must be unique across your gcp account
  location      = "asia-southeast2"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}