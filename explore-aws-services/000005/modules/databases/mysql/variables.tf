variable "env" {
  type        = string
  description = "The environment that deploys this module"
}

variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_database_stage"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "The password for the database"
  type        = string
  sensitive   = true
}

variable "netowkring_remote_state_key" {
  description = "The path for the networking's remote state in S3"
  type        = string
}
