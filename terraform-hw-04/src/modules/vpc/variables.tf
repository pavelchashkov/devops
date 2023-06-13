variable "vpc_name" {
  type = string
  description = "vpc name"
}

variable "vpc_zone" {
  type = string
  description = "vpc zone"
}

variable "vpc_v4_cidr_blocks" {
  type = list(string)
  description = "vpc v4_cidr_blocks"
}