resource "local_file" "hosts_cfg" {
  depends_on = [yandex_compute_instance.web, yandex_compute_instance.database, yandex_compute_instance.storage]
  content = templatefile(
    "${path.module}/hosts.tftpl",
    {
      webservers = yandex_compute_instance.web,
      databases  = yandex_compute_instance.database,
      storage    = yandex_compute_instance.storage
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}

resource "null_resource" "hosts_provision" {
  depends_on = [local_file.hosts_cfg]

  provisioner "local-exec" {
    command = "cat ~/.ssh/id_rsa | ssh-add -"
  }

  provisioner "local-exec" {
    command = "sleep 30"
  }

  provisioner "local-exec" {
    command     = "export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i ${abspath(path.module)}/hosts.cfg ${abspath(path.module)}/test.yml"
    on_failure  = continue
    environment = { ANSIBLE_HOST_KEY_CHECKING = "False" }
  }

  triggers = {
    always_run        = timestamp()
    playbook_src_hash = file("${abspath(path.module)}/test.yml")
  }
}