variable "env" {
  type        = string
  description = "The environment in which the infrastructure is deployed (e.g., 'prod', 'stage', 'dev')."

  validation {
    condition     = contains(["prod", "stage", "dev"], var.env)
    error_message = "Invalid environment. Allowed values are 'prod' | 'stage' | 'dev'."
  }
}

variable "cidr" {
  type        = string
  description = "The cidr block of the vpc"
}

variable "azs" {
  type        = list(string)
  description = "The list of availability zones names in the region"
  default     = []
}

variable "public_subnets" {
  type        = list(string)
  description = "The list of public subnets inside the vpc"
  default     = []
}

variable "private_subnets" {
  type        = list(string)
  description = "The list of private subnets inside the vpc"
  default     = []
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable dns hostnames in the vpc"
  default     = false
}
