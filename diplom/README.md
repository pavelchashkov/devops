# Дипломный практикум в Yandex.Cloud
  * [Цели:](#цели)
  * [Этапы выполнения:](#этапы-выполнения)
     * [Создание облачной инфраструктуры](#создание-облачной-инфраструктуры)
     * [Создание Kubernetes кластера](#создание-kubernetes-кластера)
     * [Создание тестового приложения](#создание-тестового-приложения)
     * [Подготовка cистемы мониторинга и деплой приложения](#подготовка-cистемы-мониторинга-и-деплой-приложения)
     * [Установка и настройка CI/CD](#установка-и-настройка-cicd)
  * [Что необходимо для сдачи задания?](#что-необходимо-для-сдачи-задания)
  * [Как правильно задавать вопросы дипломному руководителю?](#как-правильно-задавать-вопросы-дипломному-руководителю)

**Перед началом работы над дипломным заданием изучите [Инструкция по экономии облачных ресурсов](https://github.com/netology-code/devops-materials/blob/master/cloudwork.MD).**

---
## Цели:

1. Подготовить облачную инфраструктуру на базе облачного провайдера Яндекс.Облако.
2. Запустить и сконфигурировать Kubernetes кластер.
3. Установить и настроить систему мониторинга.
4. Настроить и автоматизировать сборку тестового приложения с использованием Docker-контейнеров.
5. Настроить CI для автоматической сборки и тестирования.
6. Настроить CD для автоматического развёртывания приложения.

---
## Этапы выполнения:


### Создание облачной инфраструктуры

Для начала необходимо подготовить облачную инфраструктуру в ЯО при помощи [Terraform](https://www.terraform.io/).

Особенности выполнения:

- Бюджет купона ограничен, что следует иметь в виду при проектировании инфраструктуры и использовании ресурсов;
Для облачного k8s используйте региональный мастер(неотказоустойчивый). Для self-hosted k8s минимизируйте ресурсы ВМ и долю ЦПУ. В обоих вариантах используйте прерываемые ВМ для worker nodes.
- Следует использовать версию [Terraform](https://www.terraform.io/) не старше 1.5.x .

Предварительная подготовка к установке и запуску Kubernetes кластера.

1. Создайте сервисный аккаунт, который будет в дальнейшем использоваться Terraform для работы с инфраструктурой с необходимыми и достаточными правами. Не стоит использовать права суперпользователя
2. Подготовьте [backend](https://www.terraform.io/docs/language/settings/backends/index.html) для Terraform:  
   а. Рекомендуемый вариант: S3 bucket в созданном ЯО аккаунте(создание бакета через TF)
   б. Альтернативный вариант:  [Terraform Cloud](https://app.terraform.io/)  
3. Создайте VPC с подсетями в разных зонах доступности.
4. Убедитесь, что теперь вы можете выполнить команды `terraform destroy` и `terraform apply` без дополнительных ручных действий.
5. В случае использования [Terraform Cloud](https://app.terraform.io/) в качестве [backend](https://www.terraform.io/docs/language/settings/backends/index.html) убедитесь, что применение изменений успешно проходит, используя web-интерфейс Terraform cloud.

Ожидаемые результаты:

1. Terraform сконфигурирован и создание инфраструктуры посредством Terraform возможно без дополнительных ручных действий.
2. Полученная конфигурация инфраструктуры является предварительной, поэтому в ходе дальнейшего выполнения задания возможны изменения.

### Решение

[src/infra](./src/infra)

```shell
yc components update
yc iam create-token
terraform init

terraform plan
terraform apply
terraform destroy
```

<img src="./img/1.1.png">

<img src="./img/1.2.png">

<img src="./img/1.3.png">

<img src="./img/1.4.png">

<img src="./img/1.5.png">

<img src="./img/1.6.png">

<img src="./img/1.7.png">

<img src="./img/1.8.png">

<img src="./img/1.9.png">

<img src="./img/1.10.png">

<img src="./img/1.11.png">

<img src="./img/1.12.png">

---
### Создание Kubernetes кластера

На этом этапе необходимо создать [Kubernetes](https://kubernetes.io/ru/docs/concepts/overview/what-is-kubernetes/) кластер на базе предварительно созданной инфраструктуры.   Требуется обеспечить доступ к ресурсам из Интернета.

Это можно сделать двумя способами:

1. Рекомендуемый вариант: самостоятельная установка Kubernetes кластера.  
   а. При помощи Terraform подготовить как минимум 3 виртуальных машины Compute Cloud для создания Kubernetes-кластера. Тип виртуальной машины следует выбрать самостоятельно с учётом требовании к производительности и стоимости. Если в дальнейшем поймете, что необходимо сменить тип инстанса, используйте Terraform для внесения изменений.  
   б. Подготовить [ansible](https://www.ansible.com/) конфигурации, можно воспользоваться, например [Kubespray](https://kubernetes.io/docs/setup/production-environment/tools/kubespray/)  
   в. Задеплоить Kubernetes на подготовленные ранее инстансы, в случае нехватки каких-либо ресурсов вы всегда можете создать их при помощи Terraform.
2. Альтернативный вариант: воспользуйтесь сервисом [Yandex Managed Service for Kubernetes](https://cloud.yandex.ru/services/managed-kubernetes)  
  а. С помощью terraform resource для [kubernetes](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_cluster) создать **региональный** мастер kubernetes с размещением нод в разных 3 подсетях      
  б. С помощью terraform resource для [kubernetes node group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/kubernetes_node_group)
  
Ожидаемый результат:

1. Работоспособный Kubernetes кластер.
2. В файле `~/.kube/config` находятся данные для доступа к кластеру.
3. Команда `kubectl get pods --all-namespaces` отрабатывает без ошибок.

### Решение

[src/ansible](./src/insible)

```shell
ssh -i ~/.ssh/ya_id_ed25519 <IP_MASTER>
ssh -i ~/.ssh/ya_id_ed25519 <IP_WORKER_1>
ssh -i ~/.ssh/ya_id_ed25519 <IP_WORKER_2>

cp inventory.yaml ../ansible/inventory.yaml
ansible-playbook -i inventory.yaml --key-file ~/.ssh/ya_id_ed25519 playbook_k8s_distr.yaml

ssh -i ~/.ssh/ya_id_ed25519 <IP_MASTER>
# SUDO
kubeadm init
export KUBECONFIG=/etc/kubernetes/admin.conf

# USER
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# SUDO
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/master/manifests/calico.yaml

ssh -i ~/.ssh/ya_id_ed25519 <IP_WORKER_1>
# SUDO
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256...

ssh -i ~/.ssh/ya_id_ed25519 <IP_WORKER_2>
# SUDO
kubeadm join 10.10.1.12:6443 --token 7jcnbj.7m0m4b3zpx131uem --discovery-token-ca-cert-hash sha256...
```

<img src="./img/2.1.png">

<img src="./img/2.2.png">

<img src="./img/2.3.png">

<img src="./img/2.4.png">

<img src="./img/2.5.png">

<img src="./img/2.6.png">

<img src="./img/2.7.png">

<img src="./img/2.8.png">

<img src="./img/2.9.png">

<img src="./img/2.10.png">

<img src="./img/2.11.png">

<img src="./img/2.12.png">

<img src="./img/2.13.png">

---
### Создание тестового приложения

Для перехода к следующему этапу необходимо подготовить тестовое приложение, эмулирующее основное приложение разрабатываемое вашей компанией.

Способ подготовки:

1. Рекомендуемый вариант:  
   а. Создайте отдельный git репозиторий с простым nginx конфигом, который будет отдавать статические данные.  
   б. Подготовьте Dockerfile для создания образа приложения.  
2. Альтернативный вариант:  
   а. Используйте любой другой код, главное, чтобы был самостоятельно создан Dockerfile.

Ожидаемый результат:

1. Git репозиторий с тестовым приложением и Dockerfile.
2. Регистри с собранным docker image. В качестве регистри может быть DockerHub или [Yandex Container Registry](https://cloud.yandex.ru/services/container-registry), созданный также с помощью terraform.

### Решение

[netology-devops-app](https://gitlab.com/pavelchashkov/netology-devops-app) (submodule in current git repo)
https://hub.docker.com/repository/docker/pavelchashkov/netology-devops-app/tags

```shell
docker build -t my-app .
docker image tag my-app pavelchashkov/netology-devops-app:0.1.0
docker image tag my-app pavelchashkov/netology-devops-app:latest
docker push pavelchashkov/netology-devops-app --all-tags

git submodule add git@gitlab.com:pavelchashkov/netology-devops-app.git
git commit -m "Added the submodule netology-devops-app"
```

<img src="./img/3.1.png">

<img src="./img/3.2.png">

<img src="./img/3.3.png">

<img src="./img/3.4.png">

<img src="./img/3.5.png">

---
### Подготовка cистемы мониторинга и деплой приложения

Уже должны быть готовы конфигурации для автоматического создания облачной инфраструктуры и поднятия Kubernetes кластера.  
Теперь необходимо подготовить конфигурационные файлы для настройки нашего Kubernetes кластера.

Цель:
1. Задеплоить в кластер [prometheus](https://prometheus.io/), [grafana](https://grafana.com/), [alertmanager](https://github.com/prometheus/alertmanager), [экспортер](https://github.com/prometheus/node_exporter) основных метрик Kubernetes.
2. Задеплоить тестовое приложение, например, [nginx](https://www.nginx.com/) сервер отдающий статическую страницу.

Способ выполнения:
1. Воспользовать пакетом [kube-prometheus](https://github.com/prometheus-operator/kube-prometheus), который уже включает в себя [Kubernetes оператор](https://operatorhub.io/) для [grafana](https://grafana.com/), [prometheus](https://prometheus.io/), [alertmanager](https://github.com/prometheus/alertmanager) и [node_exporter](https://github.com/prometheus/node_exporter). При желании можете собрать все эти приложения отдельно.
2. Для организации конфигурации использовать [qbec](https://qbec.io/), основанный на [jsonnet](https://jsonnet.org/). Обратите внимание на имеющиеся функции для интеграции helm конфигов и [helm charts](https://helm.sh/)
3. Если на первом этапе вы не воспользовались [Terraform Cloud](https://app.terraform.io/), то задеплойте и настройте в кластере [atlantis](https://www.runatlantis.io/) для отслеживания изменений инфраструктуры. Альтернативный вариант 3 задания: вместо Terraform Cloud или atlantis настройте на автоматический запуск и применение конфигурации terraform из вашего git-репозитория в выбранной вами CI-CD системе при любом комите в main ветку. Предоставьте скриншоты работы пайплайна из CI/CD системы.

Ожидаемый результат:
1. Git репозиторий с конфигурационными файлами для настройки Kubernetes.
2. Http доступ к web интерфейсу grafana.
3. Дашборды в grafana отображающие состояние Kubernetes кластера.
4. Http доступ к тестовому приложению.

### Решение

```shell
# add git to packages
ansible-playbook -i inventory.yaml --key-file ~/.ssh/ya_id_ed25519 playbook_k8s_distr.yaml --tags "packages"

kubectl apply --server-side -f kube-prometheus/manifests/setup
kubectl wait --for condition=Established --all CustomResourceDefinition --namespace=monitoring
kubectl apply -f kube-prometheus/manifests/

kubectl -n monitoring delete networkpolicies.networking.k8s.io --all # сетевые политики, которые запрещают доступ
kubectl --namespace monitoring patch svc grafana -p '{"spec": {"type": "NodePort"}}'

# netology-devops-app
docker build -t pavelchashkov/netology-devops-app:0.1.1 --platform=linux/amd64 .
docker image tag pavelchashkov/netology-devops-app:0.1.1 pavelchashkov/netology-devops-app:latest
docker push pavelchashkov/netology-devops-app --all-tags

kubectl create namespace netology
kubectl get pods -n netology
kubectl apply -f app-deployment.yml
kubectl get pods -n netology
```

```
http://158.160.104.51:30435
hinma8-daVxiw-kapgyc

http://158.160.104.51:30080
```

<img src="./img/4.1.png">

<img src="./img/4.2.png">

<img src="./img/4.3.png">

<img src="./img/4.4.png">

<img src="./img/4.5.png">

<img src="./img/4.6.png">

<img src="./img/4.7.png">

<img src="./img/4.8.png">

<img src="./img/4.9.png">

<img src="./img/4.10.png">

<img src="./img/4.11.png">

<img src="./img/4.12.png">

<img src="./img/4.13.png">

---
### Установка и настройка CI/CD

Осталось настроить ci/cd систему для автоматической сборки docker image и деплоя приложения при изменении кода.

Цель:

1. Автоматическая сборка docker образа при коммите в репозиторий с тестовым приложением.
2. Автоматический деплой нового docker образа.

Можно использовать [teamcity](https://www.jetbrains.com/ru-ru/teamcity/), [jenkins](https://www.jenkins.io/), [GitLab CI](https://about.gitlab.com/stages-devops-lifecycle/continuous-integration/) или GitHub Actions.

Ожидаемый результат:

1. Интерфейс ci/cd сервиса доступен по http.
2. При любом коммите в репозиторие с тестовым приложением происходит сборка и отправка в регистр Docker образа.
3. При создании тега (например, v1.0.0) происходит сборка и отправка с соответствующим label в регистри, а также деплой соответствующего Docker образа в кластер Kubernetes.

### Решение

```shell
ansible-playbook -i inventory.yaml --key-file ~/.ssh/ya_id_ed25519 playbook_k8s_distr.yaml --tags "helm"

https://docs.gitlab.com/runner/install/kubernetes.html

# VM with kubectl
helm repo add gitlab https://charts.gitlab.io
helm show values gitlab/gitlab-runner > gitlab-runner.yml
nano gitlab-runner.yml

# - gitlab-runner.yml
gitlabUrl: https://gitlab.com/
runnerToken: "***************"
clusterWideAccess: true
# -

kubectl create namespace gitlab-runner
helm install --namespace gitlab-runner gitlab-runner -f gitlab-runner.yml gitlab/gitlab-runner

# don`t use this method on the prod server (use RBAC)
kubectl create clusterrolebinding --clusterrole=cluster-admin -n gitlab-runner --serviceaccount=gitlab-runner:default gitlab-runner
```

<img src="./img/5.1.png">

<img src="./img/5.2.png">

<img src="./img/5.3.png">

<img src="./img/5.4.png">

<img src="./img/5.5.png">

<img src="./img/5.6.png">

<img src="./img/5.7.png">

<img src="./img/5.8.png">

<img src="./img/5.9.png">

<img src="./img/5.10.png">

<img src="./img/5.11.png">

<img src="./img/5.12.png">

<img src="./img/5.13.png">

<img src="./img/5.14.png">

<img src="./img/5.15.png">

<img src="./img/5.16.png">

<img src="./img/5.17.png">

<img src="./img/5.18.png">

<img src="./img/5.19.png">

<img src="./img/5.20.png">

<img src="./img/5.21.png">

<img src="./img/5.22.png">

<img src="./img/5.23.png">

---
## Что необходимо для сдачи задания?

1. Репозиторий с конфигурационными файлами Terraform и готовность продемонстрировать создание всех ресурсов с нуля.
2. Пример pull request с комментариями созданными atlantis'ом или снимки экрана из Terraform Cloud или вашего CI-CD-terraform pipeline.
3. Репозиторий с конфигурацией ansible, если был выбран способ создания Kubernetes кластера при помощи ansible.
4. Репозиторий с Dockerfile тестового приложения и ссылка на собранный docker image.
5. Репозиторий с конфигурацией Kubernetes кластера.
6. Ссылка на тестовое приложение и веб интерфейс Grafana с данными доступа.
7. Все репозитории рекомендуется хранить на одном ресурсе (github, gitlab)