# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).
2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.
3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.
5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).
6. Зайдите под admin\admin, поменяйте пароль на свой.
7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).
8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

## Решение

<img src="./img/1.png">

<img src="./img/4.png">

<img src="./img/2.png">

<img src="./img/3.png">

## Знакомоство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.
2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.
5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.
6. Посмотрите результат в интерфейсе.
7. Исправьте ошибки, которые он выявил, включая warnings.
8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.
9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.

## Решение

Проект расположен в директории ./example

<img src="./img/5.png">

<img src="./img/6.png">

Код проекта перед проверкой

```python
def increment(index):
    index =+ 1
    return index
def get_square(numb):
    return numb*numb
def print_numb(numb):
    print("Number is {}".format(numb))
    pass

index = 0
while (index < 10):
    index = increment(index)
    print(get_square(index))
```

Запуск sonar-scanner

```shell
sonar-scanner \
  -Dsonar.projectKey=example \
  -Dsonar.sources=. \
  -Dsonar.host.url=http://51.250.104.110:9000 \
  -Dsonar.login=***************************** \
  -Dsonar.coverage.exclusions=fail.py
```

<img src="./img/7.png">

<img src="./img/8.png">

<img src="./img/9.png">

<img src="./img/10.png">

Код проекта с исправлениями

```python
def increment(num=0):
    num += 1
    return num


def get_square(numb):
    return numb*numb


def print_numb(numb):
    print("Number is {}".format(numb))


index = 0
while index < 10:
    index = increment(index)
    print(get_square(index))
```

Запуск sonar-scanner

<img src="./img/13.png">

<img src="./img/14.png">

<img src="./img/15.png">

Исправлены все ошибки и предупреждения

## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.
4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

## Решение

* Файл [app-8_282.tar.gz](java_app/app-8_282.tar.gz)
* Файл [maven-metadata.xml](java_app/maven-metadata.xml)

<img src="./img/16.png">

<img src="./img/17.png">

<img src="./img/18.png">

<img src="./img/19.png">

<img src="./img/17.png">

<img src="./img/20.png">

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.
5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.


## Решение

<img src="./img/21.png">

* Файл [pom.xml](mvn/pom.xml)

```shell
mvn package
```

<img src="./img/22.png">

```shell
ls ~/.m2/repository/netology/java/8_282/
```

<img src="./img/23.png">

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---
