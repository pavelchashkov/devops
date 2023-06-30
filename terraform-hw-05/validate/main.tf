variable "ip_address" {
  type        = string
  description = "ip_address"
  default = "127.0.0.1"
  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ip_address))
    error_message = "Invalid IP address provided."
  }
}

variable "list_of_ip_addresses" {
  type = list(string)
  description = "list_of_ip_addresses"
  default = ["127.0.0.1"]
  validation {
    condition = alltrue([
      for a in var.list_of_ip_addresses : can(cidrhost("${a}/32", 0))
    ])
    error_message = "All elements must be valid IPv4 addresses."
  }
}

output "ip_address" {
  value = var.ip_address
}

output "list_of_ip_addresses" {
  value = var.list_of_ip_addresses
}