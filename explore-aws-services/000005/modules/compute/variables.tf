variable "env" {
  type        = string
  description = "The environment in which the infrastructure is deployed (e.g., 'production', 'staging', 'development')."
}

variable "networking_remote_state_bucket" {
  description = "The name of the S3 bucket used for the networking's remote state storage"
  type        = string
}

variable "networking_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the networking's remote state storage"
  type        = string
}

