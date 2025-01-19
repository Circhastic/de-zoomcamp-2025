variable "credentials" {
  description = "My Credentials / Service Account Key File"
  default     = "./keys/creds.json"
}

variable "project" {
  description = "Project ID"
  default     = "terraform-demo-447113"
}

variable "region" {
  description = "Project Region"
  default     = "ASIA"
}

variable "location" {
  description = "Project Location"
  default     = "ASIA-SOUTHEAST2"
}

variable "bq_dataset_name" {
  description = "BigQuery Dataset Name"
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  default     = "terraform-demo-447113-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Storage Bucket Class"
  default     = "STANDARD"
}