variable "vm_prefix_name" {
  type = string
  default = "netology-develop-platform"
}

# ---------- vm_web ---------------

variable "vm_web" {
  type = object({
    name = string,
    platform_id = string

  })
  default = {
    name: "vm_web",
    platform_id: "standard-v1"
  }
}

variable "vm_web_resources" {
  type = object({
    cores = number
    memory = number
    core_fraction = number
  })
  default = {
    cores: 2,
    memory: 1,
    core_fraction: 5
  }
}

variable "vm_web_metadata" {
  type = object({
    serial_port_enabled = number
    ssh_keys = string
  })
  default = {
    serial_port_enabled: 1,
    ssh_keys: "user:ssh_key",
  }
}

variable "vm_web_user" {
  type = string
  default = "ubuntu"
}

# ---------- vm_db ---------------

variable "vm_db" {
  type = object({
    name = string,
    platform_id = string

  })
  default = {
    name: "vm_db",
    platform_id: "standard-v1"
  }
}

variable "vm_db_resources" {
  type = object({
    cores = number
    memory = number
    core_fraction = number
  })
  default = {
    cores: 2,
    memory: 2,
    core_fraction: 20
  }
}

variable "vm_db_metadata" {
  type = object({
    serial_port_enabled = number
    ssh_keys = string
  })
  default = {
    serial_port_enabled: 1,
    ssh_keys: "user:ssh_key",
  }
}

variable "vm_db_user" {
  type = string
  default = "ubuntu"
}