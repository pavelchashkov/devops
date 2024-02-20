# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения. 
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

### Решение

[helm-chart](./src/helm-chart/)

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Решение

```shell
helm create helm-chart

helm upgrade --install --atomic nginx-1-app1 helm-chart/ --namespace app1
kubectl get pod -n app1
helm -n app1 list

helm upgrade --install --atomic nginx-2-app1 helm-chart/ --namespace app1 --set image.tag=1.22.0
kubectl get pod -n app1
helm -n app1 list

helm upgrade --install --atomic nginx-1-app2 helm-chart/ --namespace app2 -f values.app2.yaml
kubectl get pod -n app2
helm -n app2 list
```

<img src="./img/1.png">

<img src="./img/2.png">

<img src="./img/3.png">

<img src="./img/4.png">

<img src="./img/5.png">

<img src="./img/6.png">

<img src="./img/8.png">

<img src="./img/9.png">

<img src="./img/10.png">

<img src="./img/11.png">

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

