variable "credentials" {
  description = "My Credentials"
  default     = "./keys/my-creds.json"
  #directory of credential file
}


variable "project" {
  description = "Project"
  #default project name, ex: my-project-123456
  default     = "de-course-496106"
}

variable "region" {
  description = "Region"
  #your region, ex: us-central1, us-east1, etc
  default     = "asia-southeast1"
}

variable "location" {
  description = "Project Location"
  #your location, ex: US, EU, etc
  default     = "asia-southeast1"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #name of the dataset 
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #name of bucket must be globally unique.
  default     = "de-course-496106-terra-bucket"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}