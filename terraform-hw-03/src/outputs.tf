locals {
  all_mv_groups = [yandex_compute_instance.storage, yandex_compute_instance.web, yandex_compute_instance.database]
}

output "all_vms" {
  value = flatten([
    for gr in local.all_mv_groups: [
      for vm in gr: {
        name = vm.name,
        id = vm.id,
        fqdn = vm.fqdn
      }
    ]
  ])
}