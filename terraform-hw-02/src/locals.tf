locals {
  ssh-keys = "${var.vm_db_user}:${var.vms_ssh_root_key}"
  vm_web_name = "${var.vm_prefix_name}-web"
  vm_db_name = "${var.vm_prefix_name}-db"
}