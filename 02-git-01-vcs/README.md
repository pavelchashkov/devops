devops-netology (git)

Согласно файлу terraform/.gitignore системой контроля версий git будут игнорироваться (terraform - как корневая директория):
* вложенная на любом уровне директория `.terraform` и все файлы в ней (`**/.terraform/*`)
* файлы с расширением tfstate и любыми расширениями после tfstate (`*.tfstate` и `*.tfstate.*`)
* файлы `crash.log` и любыми символами в расширении между crash и log (`crash.log` и `crash.*.log`)
* файлы с расширениями `tfvars` и `tfvars.json` (`*.tfvars` и `*.tfvars.json`)
* файлы `override.tf`, `override.tf.json` и заканчивающиеся на `_override.tf` и `_override.tf.json`
* файлы конфигураций `.terraformrc` и `terraform.rc`
