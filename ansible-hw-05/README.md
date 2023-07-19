# Домашнее задание к занятию 5 «Тестирование roles»

## Подготовка к выполнению

1. Установите molecule: `pip3 install "molecule==3.5.2"` и драйвера `pip3 install molecule_docker molecule_podman`.
2. Выполните `docker pull aragast/netology:latest` —  это образ с podman, tox и несколькими пайтонами (3.7 и 3.9) внутри.

## Основная часть

Ваша цель — настроить тестирование ваших ролей. 

Задача — сделать сценарии тестирования для vector. 

Ожидаемый результат — все сценарии успешно проходят тестирование ролей.

### Molecule

1. Запустите  `molecule test -s centos_7` внутри корневой директории clickhouse-role, посмотрите на вывод команды. Данная команда может отработать с ошибками, это нормально. Наша цель - посмотреть как другие в реальном мире используют молекулу.
2. Перейдите в каталог с ролью vector-role и создайте сценарий тестирования по умолчанию при помощи `molecule init scenario --driver-name docker`.
3. Добавьте несколько разных дистрибутивов (centos:8, ubuntu:latest) для инстансов и протестируйте роль, исправьте найденные ошибки, если они есть.
4. Добавьте несколько assert в verify.yml-файл для  проверки работоспособности vector-role (проверка, что конфиг валидный, проверка успешности запуска и др.). 
5. Запустите тестирование роли повторно и проверьте, что оно прошло успешно.
5. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

### Tox

1. Добавьте в директорию с vector-role файлы из [директории](./example).
2. Запустите `docker run --privileged=True -v <path_to_repo>:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash`, где path_to_repo — путь до корня репозитория с vector-role на вашей файловой системе.
3. Внутри контейнера выполните команду `tox`, посмотрите на вывод.
5. Создайте облегчённый сценарий для `molecule` с драйвером `molecule_podman`. Проверьте его на исполнимость.
6. Пропишите правильную команду в `tox.ini`, чтобы запускался облегчённый сценарий.
8. Запустите команду `tox`. Убедитесь, что всё отработало успешно.
9. Добавьте новый тег на коммит с рабочим сценарием в соответствии с семантическим версионированием.

После выполнения у вас должно получится два сценария molecule и один tox.ini файл в репозитории. Не забудьте указать в ответе теги решений Tox и Molecule заданий. В качестве решения пришлите ссылку на  ваш репозиторий и скриншоты этапов выполнения задания. 

## Необязательная часть

1. Проделайте схожие манипуляции для создания роли LightHouse.
2. Создайте сценарий внутри любой из своих ролей, который умеет поднимать весь стек при помощи всех ролей.
3. Убедитесь в работоспособности своего стека. Создайте отдельный verify.yml, который будет проверять работоспособность интеграции всех инструментов между ними.
4. Выложите свои roles в репозитории.

В качестве решения пришлите ссылки и скриншоты этапов выполнения задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

# Решение

## Запуск molecule в clickhouse

2.1.
```shell
molecule test -s centos_7
```

<img src="./img/1.png">
...
<img src="./img/2.png">

## Molecule

2.2. Создан сценарий default

<img src="./img/3.png">

2.3. Добавлены platforms для 
* ubuntu 18.04 / ubuntu 20.04
* centos 7 / centos 8

Добавлены вложенные таски для определения платформы

```yaml
- name: Include tasks install CentOS
  ansible.builtin.include_tasks: install/CentOS.yml
  when: ansible_distribution == "CentOS"

- name: Include tasks install Ubuntu
  ansible.builtin.include_tasks: install/Ubuntu.yml
  when: ansible_distribution == "Ubuntu"
```

<img src="./img/4.png">

2.4. Добавлен assert для проверки службы vector

```yaml
- name: Verify
  hosts: all
  gather_facts: false
  tasks:
    - name: Ensure vector service started
      ansible.builtin.service:
        name: vector
        state: started
```

2.5. Запуск тестирования

```shell
molecule test
```

<img src="./img/5.png">
...
<img src="./img/6.png">
...
<img src="./img/7.png">

2.6. Добавлен новый тэг 1.1.0 (т.к. расширение функционала без потери обратной совместимости)

## Tox

2.1. Добавлены файлы 
* tox-requirements.ini
* tox.ini

2.2. Запуск контейнера

```shell
docker run --privileged=True -v /home/pavel/projects/ansible-vector:/opt/vector-role -w /opt/vector-role -it aragast/netology:latest /bin/bash
```

2.3. Запуск tox в контейнере

<details>
  <summary>Листинг выполнения</summary>

```shell
[root@0b2acb72dfe3 vector-role]# tox
py37-ansible210 create: /opt/vector-role/.tox/py37-ansible210
py37-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='4010838038'
py37-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py37-ansible30 create: /opt/vector-role/.tox/py37-ansible30
py37-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='4010838038'
py37-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py37-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible210 create: /opt/vector-role/.tox/py39-ansible210
py39-ansible210 installdeps: -rtox-requirements.txt, ansible<3.0
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.2,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible210 run-test-pre: PYTHONHASHSEED='4010838038'
py39-ansible210 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible210/bin/molecule test -s compatibility --destroy always (exited with code 1)
py39-ansible30 create: /opt/vector-role/.tox/py39-ansible30
py39-ansible30 installdeps: -rtox-requirements.txt, ansible<3.1
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.2,ansible-core==2.15.2,ansible-lint==5.1.3,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.4,jsonschema-specifications==2023.7.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==2.0.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,referencing==0.30.0,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.9.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3
py39-ansible30 run-test-pre: PYTHONHASHSEED='4010838038'
py39-ansible30 run-test: commands[0] | molecule test -s compatibility --destroy always
CRITICAL 'molecule/compatibility/molecule.yml' glob failed.  Exiting.
ERROR: InvocationError for command /opt/vector-role/.tox/py39-ansible30/bin/molecule test -s compatibility --destroy always (exited with code 1)
__________________________________________________________ summary __________________________________________________________
ERROR:   py37-ansible210: commands failed
ERROR:   py37-ansible30: commands failed
ERROR:   py39-ansible210: commands failed
ERROR:   py39-ansible30: commands failed
```

</details>

2.4. Создание сценария podman

```shell
molecule init scenario --driver-name=podman podman
```

2.5. Конфигурация tox на запуск c podman

tox.ini

```ini
[tox]
minversion = 1.8
basepython = python3.9
envlist = py{37,39}-ansible{210,30}
skipsdist = true

[testenv]
passenv = *
deps =
    -r tox-requirements.txt
    ansible210: ansible<3.0
    ansible30: ansible<3.1
commands =
    ; {posargs:molecule test -s compatibility --destroy always}
    {posargs:pip3.9 install -r requirements.txt}
    {posargs:molecule test -s podman}
```

tox-requirements.txt

```text
selinux
ansible-lint==6.17.2
yamllint==1.32.0
lxml
molecule==5.1.0
molecule_podman
jmespath
```

```yaml
commands =
    {posargs:molecule test -s podman}
```

<details>
  <summary>Листинг выполнения</summary>

```shell
[root@690052a0e862 vector-role]# tox
py37-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible210 run-test-pre: PYTHONHASHSEED='3120477898'
py37-ansible210 run-test: commands[0] | pip3.9 install -r requirements.txt
WARNING: test command found but not installed in testenv
  cmd: /usr/local/bin/pip3.9
  env: /opt/vector-role/.tox/py37-ansible210
Maybe you forgot to specify a dependency? See also the allowlist_externals envconfig setting.

DEPRECATION WARNING: this will be an error in tox 4 and above!
Collecting ansible-compat==4.1.2
  Downloading ansible_compat-4.1.2-py3-none-any.whl (21 kB)
Collecting ansible-core==2.15.1
  Downloading ansible_core-2.15.1-py3-none-any.whl (2.2 MB)
     |████████████████████████████████| 2.2 MB 1.5 MB/s 
Collecting ansible-lint==6.17.2
  Downloading ansible_lint-6.17.2-py3-none-any.whl (279 kB)
     |████████████████████████████████| 279 kB 3.7 MB/s 
Collecting arrow==1.2.3
  Downloading arrow-1.2.3-py3-none-any.whl (66 kB)
     |████████████████████████████████| 66 kB 1.3 MB/s 
Collecting attrs==23.1.0
  Downloading attrs-23.1.0-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 1.2 MB/s 
Collecting binaryornot==0.4.4
  Downloading binaryornot-0.4.4-py2.py3-none-any.whl (9.0 kB)
Collecting black==23.7.0
  Downloading black-23.7.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.7 MB)
     |████████████████████████████████| 1.7 MB 871 kB/s 
Collecting bracex==2.3.post1
  Downloading bracex-2.3.post1-py3-none-any.whl (12 kB)
Collecting certifi==2023.5.7
  Downloading certifi-2023.5.7-py3-none-any.whl (156 kB)
     |████████████████████████████████| 156 kB 926 kB/s 
Collecting cffi==1.15.1
  Downloading cffi-1.15.1-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (441 kB)
     |████████████████████████████████| 441 kB 788 kB/s 
Collecting chardet==5.1.0
  Downloading chardet-5.1.0-py3-none-any.whl (199 kB)
     |████████████████████████████████| 199 kB 602 kB/s 
Collecting charset-normalizer==3.2.0
  Downloading charset_normalizer-3.2.0-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (202 kB)
     |████████████████████████████████| 202 kB 609 kB/s 
Collecting click==8.1.5
  Downloading click-8.1.5-py3-none-any.whl (98 kB)
     |████████████████████████████████| 98 kB 444 kB/s 
Collecting click-help-colors==0.9.1
  Downloading click_help_colors-0.9.1-py3-none-any.whl (5.5 kB)
Collecting cookiecutter==2.2.3
  Downloading cookiecutter-2.2.3-py3-none-any.whl (39 kB)
Collecting cryptography==41.0.2
  Downloading cryptography-41.0.2-cp37-abi3-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (4.3 MB)
     |████████████████████████████████| 4.3 MB 502 kB/s 
Collecting distro==1.8.0
  Downloading distro-1.8.0-py3-none-any.whl (20 kB)
Collecting docker==6.1.3
  Downloading docker-6.1.3-py3-none-any.whl (148 kB)
     |████████████████████████████████| 148 kB 953 kB/s 
Collecting enrich==1.2.7
  Downloading enrich-1.2.7-py3-none-any.whl (8.7 kB)
Collecting filelock==3.12.2
  Downloading filelock-3.12.2-py3-none-any.whl (10 kB)
Collecting idna==3.4
  Downloading idna-3.4-py3-none-any.whl (61 kB)
     |████████████████████████████████| 61 kB 49 kB/s 
Collecting Jinja2==3.1.2
  Downloading Jinja2-3.1.2-py3-none-any.whl (133 kB)
     |████████████████████████████████| 133 kB 2.2 MB/s 
Collecting jsonschema==4.18.3
  Downloading jsonschema-4.18.3-py3-none-any.whl (80 kB)
     |████████████████████████████████| 80 kB 1.1 MB/s 
Collecting jsonschema-specifications==2023.6.1
  Downloading jsonschema_specifications-2023.6.1-py3-none-any.whl (17 kB)
Collecting markdown-it-py==3.0.0
  Downloading markdown_it_py-3.0.0-py3-none-any.whl (87 kB)
     |████████████████████████████████| 87 kB 887 kB/s 
Collecting MarkupSafe==2.1.3
  Downloading MarkupSafe-2.1.3-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (25 kB)
Collecting mdurl==0.1.2
  Downloading mdurl-0.1.2-py3-none-any.whl (10.0 kB)
Collecting molecule==5.1.0
  Downloading molecule-5.1.0-py3-none-any.whl (240 kB)
     |████████████████████████████████| 240 kB 772 kB/s 
Collecting molecule-plugins==23.4.1
  Downloading molecule_plugins-23.4.1-py3-none-any.whl (67 kB)
     |████████████████████████████████| 67 kB 900 kB/s 
Collecting mypy-extensions==1.0.0
  Downloading mypy_extensions-1.0.0-py3-none-any.whl (4.7 kB)
Collecting packaging==23.1
  Downloading packaging-23.1-py3-none-any.whl (48 kB)
     |████████████████████████████████| 48 kB 1.2 MB/s 
Collecting pathspec==0.11.1
  Downloading pathspec-0.11.1-py3-none-any.whl (29 kB)
Collecting platformdirs==3.9.1
  Downloading platformdirs-3.9.1-py3-none-any.whl (16 kB)
Collecting pluggy==1.2.0
  Downloading pluggy-1.2.0-py3-none-any.whl (17 kB)
Collecting pycparser==2.21
  Downloading pycparser-2.21-py2.py3-none-any.whl (118 kB)
     |████████████████████████████████| 118 kB 1.2 MB/s 
Collecting Pygments==2.15.1
  Downloading Pygments-2.15.1-py3-none-any.whl (1.1 MB)
     |████████████████████████████████| 1.1 MB 2.3 MB/s 
Collecting python-dateutil==2.8.2
  Downloading python_dateutil-2.8.2-py2.py3-none-any.whl (247 kB)
     |████████████████████████████████| 247 kB 1.9 MB/s 
Collecting python-slugify==8.0.1
  Downloading python_slugify-8.0.1-py2.py3-none-any.whl (9.7 kB)
Collecting PyYAML==6.0
  Downloading PyYAML-6.0-cp39-cp39-manylinux_2_5_x86_64.manylinux1_x86_64.manylinux_2_12_x86_64.manylinux2010_x86_64.whl (661 kB)
     |████████████████████████████████| 661 kB 1.8 MB/s 
Collecting referencing==0.29.1
  Downloading referencing-0.29.1-py3-none-any.whl (25 kB)
Collecting requests==2.31.0
  Downloading requests-2.31.0-py3-none-any.whl (62 kB)
     |████████████████████████████████| 62 kB 466 kB/s 
Collecting resolvelib==1.0.1
  Downloading resolvelib-1.0.1-py2.py3-none-any.whl (17 kB)
Collecting rich==13.4.2
  Downloading rich-13.4.2-py3-none-any.whl (239 kB)
     |████████████████████████████████| 239 kB 863 kB/s 
Collecting rpds-py==0.8.10
  Downloading rpds_py-0.8.10-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.whl (1.2 MB)
     |████████████████████████████████| 1.2 MB 849 kB/s 
Collecting ruamel.yaml==0.17.32
  Downloading ruamel.yaml-0.17.32-py3-none-any.whl (112 kB)
     |████████████████████████████████| 112 kB 861 kB/s 
Collecting ruamel.yaml.clib==0.2.7
  Downloading ruamel.yaml.clib-0.2.7-cp39-cp39-manylinux_2_17_x86_64.manylinux2014_x86_64.manylinux_2_24_x86_64.whl (519 kB)
     |████████████████████████████████| 519 kB 1.8 MB/s 
Collecting selinux==0.3.0
  Downloading selinux-0.3.0-py2.py3-none-any.whl (4.2 kB)
Collecting six==1.16.0
  Using cached six-1.16.0-py2.py3-none-any.whl (11 kB)
Collecting subprocess-tee==0.4.1
  Downloading subprocess_tee-0.4.1-py3-none-any.whl (5.1 kB)
Collecting text-unidecode==1.3
  Downloading text_unidecode-1.3-py2.py3-none-any.whl (78 kB)
     |████████████████████████████████| 78 kB 696 kB/s 
Collecting urllib3==2.0.3
  Downloading urllib3-2.0.3-py3-none-any.whl (123 kB)
     |████████████████████████████████| 123 kB 1.1 MB/s 
Collecting wcmatch==8.4.1
  Downloading wcmatch-8.4.1-py3-none-any.whl (39 kB)
Collecting websocket-client==1.6.1
  Downloading websocket_client-1.6.1-py3-none-any.whl (56 kB)
     |████████████████████████████████| 56 kB 1.2 MB/s 
Collecting yamllint==1.32.0
  Downloading yamllint-1.32.0-py3-none-any.whl (65 kB)
     |████████████████████████████████| 65 kB 415 kB/s 
Collecting typing-extensions>=4.5.0; python_version < "3.10"
  Downloading typing_extensions-4.7.1-py3-none-any.whl (33 kB)
Collecting importlib-resources<5.1,>=5.0; python_version < "3.10"
  Downloading importlib_resources-5.0.7-py3-none-any.whl (24 kB)
Collecting tomli>=1.1.0; python_version < "3.11"
  Downloading tomli-2.0.1-py3-none-any.whl (12 kB)
Installing collected packages: PyYAML, importlib-resources, resolvelib, MarkupSafe, Jinja2, pycparser, cffi, cryptography, packaging, ansible-core, attrs, rpds-py, referencing, jsonschema-specifications, jsonschema, subprocess-tee, typing-extensions, ansible-compat, bracex, wcmatch, ruamel.yaml.clib, ruamel.yaml, filelock, pathspec, click, mypy-extensions, platformdirs, tomli, black, yamllint, charset-normalizer, idna, certifi, urllib3, requests, mdurl, markdown-it-py, Pygments, rich, ansible-lint, six, python-dateutil, arrow, chardet, binaryornot, click-help-colors, text-unidecode, python-slugify, cookiecutter, distro, websocket-client, docker, enrich, pluggy, molecule, molecule-plugins, selinux
Successfully installed Jinja2-3.1.2 MarkupSafe-2.1.3 PyYAML-6.0 Pygments-2.15.1 ansible-compat-4.1.2 ansible-core-2.15.1 ansible-lint-6.17.2 arrow-1.2.3 attrs-23.1.0 binaryornot-0.4.4 black-23.7.0 bracex-2.3.post1 certifi-2023.5.7 cffi-1.15.1 chardet-5.1.0 charset-normalizer-3.2.0 click-8.1.5 click-help-colors-0.9.1 cookiecutter-2.2.3 cryptography-41.0.2 distro-1.8.0 docker-6.1.3 enrich-1.2.7 filelock-3.12.2 idna-3.4 importlib-resources-5.0.7 jsonschema-4.18.3 jsonschema-specifications-2023.6.1 markdown-it-py-3.0.0 mdurl-0.1.2 molecule-5.1.0 molecule-plugins-23.4.1 mypy-extensions-1.0.0 packaging-23.1 pathspec-0.11.1 platformdirs-3.9.1 pluggy-1.2.0 pycparser-2.21 python-dateutil-2.8.2 python-slugify-8.0.1 referencing-0.29.1 requests-2.31.0 resolvelib-1.0.1 rich-13.4.2 rpds-py-0.8.10 ruamel.yaml-0.17.32 ruamel.yaml.clib-0.2.7 selinux-0.3.0 six-1.16.0 subprocess-tee-0.4.1 text-unidecode-1.3 tomli-2.0.1 typing-extensions-4.7.1 urllib3-2.0.3 wcmatch-8.4.1 websocket-client-1.6.1 yamllint-1.32.0
WARNING: You are using pip version 20.2.3; however, version 23.2 is available.
You should consider upgrading via the '/usr/local/bin/python3.9 -m pip install --upgrade pip' command.
py37-ansible210 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running podman > dependency
INFO     Running ansible-galaxy collection install -v --force containers.podman:>=1.7.0
INFO     Running ansible-galaxy collection install -v --force ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '925278672814.80', 'results_file': '/root/.ansible_async/925278672814.80', 'changed': True, 'failed': False, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos7 registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos7)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos7 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos7: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
FAILED - RETRYING: Wait for instance(s) creation to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (299 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (298 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (297 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (296 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (295 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (294 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (293 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (292 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (291 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (290 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (289 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (288 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (287 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (286 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (285 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (284 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (283 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (282 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (281 retries left).
FAILED - RETRYING: Wait for instance(s) creation to complete (280 retries left).
changed: [localhost] => (item=centos7)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
changed: [centos7]

TASK [vector-role : Vector | Install package] **********************************
changed: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
changed: [centos7]

TASK [vector-role : Vector | Register service] *********************************
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
ok: [centos7]

TASK [vector-role : Vector | Install package] **********************************
ok: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
ok: [centos7]

TASK [vector-role : Vector | Register service] *********************************
ok: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '738477126745.3706', 'results_file': '/root/.ansible_async/738477126745.3706', 'changed': True, 'failed': False, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py37-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==1.0.0,ansible-lint==5.1.3,arrow==1.2.3,bcrypt==4.0.1,binaryornot==0.4.4,bracex==2.3.post1,cached-property==1.5.2,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.6,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,enrich==1.2.7,idna==3.4,importlib-metadata==6.7.0,Jinja2==3.1.2,jmespath==1.0.1,lxml==4.9.3,markdown-it-py==2.2.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==3.5.2,molecule-podman==1.1.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==5.4.1,requests==2.31.0,rich==13.4.2,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.2.1,six==1.16.0,subprocess-tee==0.3.5,tenacity==8.2.2,text-unidecode==1.3,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,yamllint==1.26.3,zipp==3.15.0
py37-ansible30 run-test-pre: PYTHONHASHSEED='3120477898'
py37-ansible30 run-test: commands[0] | pip3.9 install -r requirements.txt
WARNING: test command found but not installed in testenv
  cmd: /usr/local/bin/pip3.9
  env: /opt/vector-role/.tox/py37-ansible30
Maybe you forgot to specify a dependency? See also the allowlist_externals envconfig setting.

DEPRECATION WARNING: this will be an error in tox 4 and above!
Requirement already satisfied: ansible-compat==4.1.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 1)) (4.1.2)
Requirement already satisfied: ansible-core==2.15.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: ansible-lint==6.17.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 3)) (6.17.2)
Requirement already satisfied: arrow==1.2.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 4)) (1.2.3)
Requirement already satisfied: attrs==23.1.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 5)) (23.1.0)
Requirement already satisfied: binaryornot==0.4.4 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 6)) (0.4.4)
Requirement already satisfied: black==23.7.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 7)) (23.7.0)
Requirement already satisfied: bracex==2.3.post1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 8)) (2.3.post1)
Requirement already satisfied: certifi==2023.5.7 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 9)) (2023.5.7)
Requirement already satisfied: cffi==1.15.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 10)) (1.15.1)
Requirement already satisfied: chardet==5.1.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 11)) (5.1.0)
Requirement already satisfied: charset-normalizer==3.2.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 12)) (3.2.0)
Requirement already satisfied: click==8.1.5 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 13)) (8.1.5)
Requirement already satisfied: click-help-colors==0.9.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 14)) (0.9.1)
Requirement already satisfied: cookiecutter==2.2.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 15)) (2.2.3)
Requirement already satisfied: cryptography==41.0.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 16)) (41.0.2)
Requirement already satisfied: distro==1.8.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 17)) (1.8.0)
Requirement already satisfied: docker==6.1.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 18)) (6.1.3)
Requirement already satisfied: enrich==1.2.7 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 19)) (1.2.7)
Requirement already satisfied: filelock==3.12.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 20)) (3.12.2)
Requirement already satisfied: idna==3.4 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 21)) (3.4)
Requirement already satisfied: Jinja2==3.1.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 22)) (3.1.2)
Requirement already satisfied: jsonschema==4.18.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 23)) (4.18.3)
Requirement already satisfied: jsonschema-specifications==2023.6.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 24)) (2023.6.1)
Requirement already satisfied: markdown-it-py==3.0.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 25)) (3.0.0)
Requirement already satisfied: MarkupSafe==2.1.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 26)) (2.1.3)
Requirement already satisfied: mdurl==0.1.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 27)) (0.1.2)
Requirement already satisfied: molecule==5.1.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 28)) (5.1.0)
Requirement already satisfied: molecule-plugins==23.4.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 29)) (23.4.1)
Requirement already satisfied: mypy-extensions==1.0.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 30)) (1.0.0)
Requirement already satisfied: packaging==23.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 31)) (23.1)
Requirement already satisfied: pathspec==0.11.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 32)) (0.11.1)
Requirement already satisfied: platformdirs==3.9.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 33)) (3.9.1)
Requirement already satisfied: pluggy==1.2.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 34)) (1.2.0)
Requirement already satisfied: pycparser==2.21 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 35)) (2.21)
Requirement already satisfied: Pygments==2.15.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 36)) (2.15.1)
Requirement already satisfied: python-dateutil==2.8.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 37)) (2.8.2)
Requirement already satisfied: python-slugify==8.0.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 38)) (8.0.1)
Requirement already satisfied: PyYAML==6.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 39)) (6.0)
Requirement already satisfied: referencing==0.29.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 40)) (0.29.1)
Requirement already satisfied: requests==2.31.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 41)) (2.31.0)
Requirement already satisfied: resolvelib==1.0.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 42)) (1.0.1)
Requirement already satisfied: rich==13.4.2 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 43)) (13.4.2)
Requirement already satisfied: rpds-py==0.8.10 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 44)) (0.8.10)
Requirement already satisfied: ruamel.yaml==0.17.32 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 45)) (0.17.32)
Requirement already satisfied: ruamel.yaml.clib==0.2.7 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 46)) (0.2.7)
Requirement already satisfied: selinux==0.3.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 47)) (0.3.0)
Requirement already satisfied: six==1.16.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 48)) (1.16.0)
Requirement already satisfied: subprocess-tee==0.4.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 49)) (0.4.1)
Requirement already satisfied: text-unidecode==1.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 50)) (1.3)
Requirement already satisfied: urllib3==2.0.3 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 51)) (2.0.3)
Requirement already satisfied: wcmatch==8.4.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 52)) (8.4.1)
Requirement already satisfied: websocket-client==1.6.1 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 53)) (1.6.1)
Requirement already satisfied: yamllint==1.32.0 in /usr/local/lib/python3.9/site-packages (from -r requirements.txt (line 54)) (1.32.0)
Requirement already satisfied: typing-extensions>=4.5.0; python_version < "3.10" in /usr/local/lib/python3.9/site-packages (from ansible-compat==4.1.2->-r requirements.txt (line 1)) (4.7.1)
Requirement already satisfied: importlib-resources<5.1,>=5.0; python_version < "3.10" in /usr/local/lib/python3.9/site-packages (from ansible-core==2.15.1->-r requirements.txt (line 2)) (5.0.7)
Requirement already satisfied: tomli>=1.1.0; python_version < "3.11" in /usr/local/lib/python3.9/site-packages (from black==23.7.0->-r requirements.txt (line 7)) (2.0.1)
WARNING: You are using pip version 20.2.3; however, version 23.2 is available.
You should consider upgrading via the '/usr/local/bin/python3.9 -m pip install --upgrade pip' command.
py37-ansible30 run-test: commands[1] | molecule test -s podman
INFO     podman scenario test matrix: dependency, lint, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/b984a4/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/b984a4/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/b984a4/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Running podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > lint
INFO     Lint is disabled.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '548454833143.3859', 'results_file': '/root/.ansible_async/548454833143.3859', 'changed': True, 'failed': False, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [get podman executable path] **********************************************
ok: [localhost]

TASK [save path to executable as fact] *****************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos7 registry username: None specified") 

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos7)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos7 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos7: None specified) 

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos7)

PLAY RECAP *********************************************************************
localhost                  : ok=8    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
changed: [centos7]

TASK [vector-role : Vector | Install package] **********************************
changed: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
changed: [centos7]

TASK [vector-role : Vector | Register service] *********************************
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
ok: [centos7]

TASK [vector-role : Vector | Install package] **********************************
ok: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
ok: [centos7]

TASK [vector-role : Vector | Register service] *********************************
ok: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'started': 1, 'finished': 0, 'ansible_job_id': '779170103977.7099', 'results_file': '/root/.ansible_async/779170103977.7099', 'changed': True, 'failed': False, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

PLAY RECAP *********************************************************************
localhost                  : ok=2    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible210 installed: ansible==2.10.7,ansible-base==2.10.17,ansible-compat==4.1.2,ansible-core==2.15.1,ansible-lint==6.17.2,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,black==23.7.0,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.5,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,docker==6.1.3,enrich==1.2.7,filelock==3.12.2,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.3,jsonschema-specifications==2023.6.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==5.1.0,molecule-plugins==23.4.1,molecule-podman==2.0.0,mypy-extensions==1.0.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,platformdirs==3.9.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==6.0,referencing==0.29.1,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.8.10,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,tomli==2.0.1,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,websocket-client==1.6.1,yamllint==1.32.0
py39-ansible210 run-test-pre: PYTHONHASHSEED='3120477898'
py39-ansible210 run-test: commands[0] | pip3.9 install -r requirements.txt
Requirement already satisfied: ansible-compat==4.1.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 1)) (4.1.2)
Requirement already satisfied: ansible-core==2.15.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: ansible-lint==6.17.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 3)) (6.17.2)
Requirement already satisfied: arrow==1.2.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 4)) (1.2.3)
Requirement already satisfied: attrs==23.1.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 5)) (23.1.0)
Requirement already satisfied: binaryornot==0.4.4 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 6)) (0.4.4)
Requirement already satisfied: black==23.7.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 7)) (23.7.0)
Requirement already satisfied: bracex==2.3.post1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 8)) (2.3.post1)
Requirement already satisfied: certifi==2023.5.7 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 9)) (2023.5.7)
Requirement already satisfied: cffi==1.15.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 10)) (1.15.1)
Requirement already satisfied: chardet==5.1.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 11)) (5.1.0)
Requirement already satisfied: charset-normalizer==3.2.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 12)) (3.2.0)
Requirement already satisfied: click==8.1.5 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 13)) (8.1.5)
Requirement already satisfied: click-help-colors==0.9.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 14)) (0.9.1)
Requirement already satisfied: cookiecutter==2.2.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 15)) (2.2.3)
Requirement already satisfied: cryptography==41.0.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 16)) (41.0.2)
Requirement already satisfied: distro==1.8.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 17)) (1.8.0)
Requirement already satisfied: docker==6.1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 18)) (6.1.3)
Requirement already satisfied: enrich==1.2.7 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 19)) (1.2.7)
Requirement already satisfied: filelock==3.12.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 20)) (3.12.2)
Requirement already satisfied: idna==3.4 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 21)) (3.4)
Requirement already satisfied: Jinja2==3.1.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 22)) (3.1.2)
Requirement already satisfied: jsonschema==4.18.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 23)) (4.18.3)
Requirement already satisfied: jsonschema-specifications==2023.6.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 24)) (2023.6.1)
Requirement already satisfied: markdown-it-py==3.0.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 25)) (3.0.0)
Requirement already satisfied: MarkupSafe==2.1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 26)) (2.1.3)
Requirement already satisfied: mdurl==0.1.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 27)) (0.1.2)
Requirement already satisfied: molecule==5.1.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 28)) (5.1.0)
Requirement already satisfied: molecule-plugins==23.4.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 29)) (23.4.1)
Requirement already satisfied: mypy-extensions==1.0.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 30)) (1.0.0)
Requirement already satisfied: packaging==23.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 31)) (23.1)
Requirement already satisfied: pathspec==0.11.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 32)) (0.11.1)
Requirement already satisfied: platformdirs==3.9.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 33)) (3.9.1)
Requirement already satisfied: pluggy==1.2.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 34)) (1.2.0)
Requirement already satisfied: pycparser==2.21 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 35)) (2.21)
Requirement already satisfied: Pygments==2.15.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 36)) (2.15.1)
Requirement already satisfied: python-dateutil==2.8.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 37)) (2.8.2)
Requirement already satisfied: python-slugify==8.0.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 38)) (8.0.1)
Requirement already satisfied: PyYAML==6.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 39)) (6.0)
Requirement already satisfied: referencing==0.29.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 40)) (0.29.1)
Requirement already satisfied: requests==2.31.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 41)) (2.31.0)
Requirement already satisfied: resolvelib==1.0.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 42)) (1.0.1)
Requirement already satisfied: rich==13.4.2 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 43)) (13.4.2)
Requirement already satisfied: rpds-py==0.8.10 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 44)) (0.8.10)
Requirement already satisfied: ruamel.yaml==0.17.32 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 45)) (0.17.32)
Requirement already satisfied: ruamel.yaml.clib==0.2.7 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 46)) (0.2.7)
Requirement already satisfied: selinux==0.3.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 47)) (0.3.0)
Requirement already satisfied: six==1.16.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 48)) (1.16.0)
Requirement already satisfied: subprocess-tee==0.4.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 49)) (0.4.1)
Requirement already satisfied: text-unidecode==1.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 50)) (1.3)
Requirement already satisfied: urllib3==2.0.3 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 51)) (2.0.3)
Requirement already satisfied: wcmatch==8.4.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 52)) (8.4.1)
Requirement already satisfied: websocket-client==1.6.1 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 53)) (1.6.1)
Requirement already satisfied: yamllint==1.32.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from -r requirements.txt (line 54)) (1.32.0)
Requirement already satisfied: typing-extensions>=4.5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-compat==4.1.2->-r requirements.txt (line 1)) (4.7.1)
Requirement already satisfied: importlib-resources<5.1,>=5.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from ansible-core==2.15.1->-r requirements.txt (line 2)) (5.0.7)
Requirement already satisfied: tomli>=1.1.0 in ./.tox/py39-ansible210/lib/python3.9/site-packages (from black==23.7.0->-r requirements.txt (line 7)) (2.0.1)
WARNING: You are using pip version 22.0.4; however, version 23.2 is available.
You should consider upgrading via the '/opt/vector-role/.tox/py39-ansible210/bin/python -m pip install --upgrade pip' command.
py39-ansible210 run-test: commands[1] | molecule test -s podman
WARNING  Driver podman does not provide a schema.
INFO     podman scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.cache/ansible-compat/f5bcd7/roles/chashkov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running podman > dependency
INFO     Running from /opt/vector-role : ansible-galaxy collection install -vvv containers.podman:>=1.7.0
INFO     Running from /opt/vector-role : ansible-galaxy collection install -vvv ansible.posix:>=1.3.0
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j305151841723.7249', 'results_file': '/root/.ansible_async/j305151841723.7249', 'changed': True, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

TASK [Delete podman network dedicated to this scenario] ************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [Get podman executable path] **********************************************
ok: [localhost]

TASK [Register podman executable path] *****************************************
ok: [localhost]

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos7 registry username: None specified") 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 
skipping: [localhost]

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos7)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos7 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos7)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
changed: [centos7]

TASK [vector-role : Vector | Install package] **********************************
changed: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
changed: [centos7]

TASK [vector-role : Vector | Register service] *********************************
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
ok: [centos7]

TASK [vector-role : Vector | Install package] **********************************
ok: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
ok: [centos7]

TASK [vector-role : Vector | Register service] *********************************
ok: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j238753015092.10418', 'results_file': '/root/.ansible_async/j238753015092.10418', 'changed': True, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

TASK [Delete podman network dedicated to this scenario] ************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
py39-ansible30 installed: ansible==3.0.0,ansible-base==2.10.17,ansible-compat==4.1.2,ansible-core==2.15.1,ansible-lint==6.17.2,arrow==1.2.3,attrs==23.1.0,bcrypt==4.0.1,binaryornot==0.4.4,black==23.7.0,bracex==2.3.post1,Cerberus==1.3.2,certifi==2023.5.7,cffi==1.15.1,chardet==5.1.0,charset-normalizer==3.2.0,click==8.1.5,click-help-colors==0.9.1,cookiecutter==2.2.3,cryptography==41.0.2,distro==1.8.0,docker==6.1.3,enrich==1.2.7,filelock==3.12.2,idna==3.4,importlib-resources==5.0.7,Jinja2==3.1.2,jmespath==1.0.1,jsonschema==4.18.3,jsonschema-specifications==2023.6.1,lxml==4.9.3,markdown-it-py==3.0.0,MarkupSafe==2.1.3,mdurl==0.1.2,molecule==5.1.0,molecule-plugins==23.4.1,molecule-podman==2.0.0,mypy-extensions==1.0.0,packaging==23.1,paramiko==2.12.0,pathspec==0.11.1,platformdirs==3.9.1,pluggy==1.2.0,pycparser==2.21,Pygments==2.15.1,PyNaCl==1.5.0,python-dateutil==2.8.2,python-slugify==8.0.1,PyYAML==6.0,referencing==0.29.1,requests==2.31.0,resolvelib==1.0.1,rich==13.4.2,rpds-py==0.8.10,ruamel.yaml==0.17.32,ruamel.yaml.clib==0.2.7,selinux==0.3.0,six==1.16.0,subprocess-tee==0.4.1,tenacity==8.2.2,text-unidecode==1.3,tomli==2.0.1,typing_extensions==4.7.1,urllib3==2.0.3,wcmatch==8.4.1,websocket-client==1.6.1,yamllint==1.32.0
py39-ansible30 run-test-pre: PYTHONHASHSEED='3120477898'
py39-ansible30 run-test: commands[0] | pip3.9 install -r requirements.txt
Requirement already satisfied: ansible-compat==4.1.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 1)) (4.1.2)
Requirement already satisfied: ansible-core==2.15.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 2)) (2.15.1)
Requirement already satisfied: ansible-lint==6.17.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 3)) (6.17.2)
Requirement already satisfied: arrow==1.2.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 4)) (1.2.3)
Requirement already satisfied: attrs==23.1.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 5)) (23.1.0)
Requirement already satisfied: binaryornot==0.4.4 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 6)) (0.4.4)
Requirement already satisfied: black==23.7.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 7)) (23.7.0)
Requirement already satisfied: bracex==2.3.post1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 8)) (2.3.post1)
Requirement already satisfied: certifi==2023.5.7 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 9)) (2023.5.7)
Requirement already satisfied: cffi==1.15.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 10)) (1.15.1)
Requirement already satisfied: chardet==5.1.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 11)) (5.1.0)
Requirement already satisfied: charset-normalizer==3.2.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 12)) (3.2.0)
Requirement already satisfied: click==8.1.5 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 13)) (8.1.5)
Requirement already satisfied: click-help-colors==0.9.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 14)) (0.9.1)
Requirement already satisfied: cookiecutter==2.2.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 15)) (2.2.3)
Requirement already satisfied: cryptography==41.0.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 16)) (41.0.2)
Requirement already satisfied: distro==1.8.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 17)) (1.8.0)
Requirement already satisfied: docker==6.1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 18)) (6.1.3)
Requirement already satisfied: enrich==1.2.7 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 19)) (1.2.7)
Requirement already satisfied: filelock==3.12.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 20)) (3.12.2)
Requirement already satisfied: idna==3.4 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 21)) (3.4)
Requirement already satisfied: Jinja2==3.1.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 22)) (3.1.2)
Requirement already satisfied: jsonschema==4.18.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 23)) (4.18.3)
Requirement already satisfied: jsonschema-specifications==2023.6.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 24)) (2023.6.1)
Requirement already satisfied: markdown-it-py==3.0.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 25)) (3.0.0)
Requirement already satisfied: MarkupSafe==2.1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 26)) (2.1.3)
Requirement already satisfied: mdurl==0.1.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 27)) (0.1.2)
Requirement already satisfied: molecule==5.1.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 28)) (5.1.0)
Requirement already satisfied: molecule-plugins==23.4.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 29)) (23.4.1)
Requirement already satisfied: mypy-extensions==1.0.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 30)) (1.0.0)
Requirement already satisfied: packaging==23.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 31)) (23.1)
Requirement already satisfied: pathspec==0.11.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 32)) (0.11.1)
Requirement already satisfied: platformdirs==3.9.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 33)) (3.9.1)
Requirement already satisfied: pluggy==1.2.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 34)) (1.2.0)
Requirement already satisfied: pycparser==2.21 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 35)) (2.21)
Requirement already satisfied: Pygments==2.15.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 36)) (2.15.1)
Requirement already satisfied: python-dateutil==2.8.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 37)) (2.8.2)
Requirement already satisfied: python-slugify==8.0.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 38)) (8.0.1)
Requirement already satisfied: PyYAML==6.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 39)) (6.0)
Requirement already satisfied: referencing==0.29.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 40)) (0.29.1)
Requirement already satisfied: requests==2.31.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 41)) (2.31.0)
Requirement already satisfied: resolvelib==1.0.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 42)) (1.0.1)
Requirement already satisfied: rich==13.4.2 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 43)) (13.4.2)
Requirement already satisfied: rpds-py==0.8.10 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 44)) (0.8.10)
Requirement already satisfied: ruamel.yaml==0.17.32 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 45)) (0.17.32)
Requirement already satisfied: ruamel.yaml.clib==0.2.7 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 46)) (0.2.7)
Requirement already satisfied: selinux==0.3.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 47)) (0.3.0)
Requirement already satisfied: six==1.16.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 48)) (1.16.0)
Requirement already satisfied: subprocess-tee==0.4.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 49)) (0.4.1)
Requirement already satisfied: text-unidecode==1.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 50)) (1.3)
Requirement already satisfied: urllib3==2.0.3 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 51)) (2.0.3)
Requirement already satisfied: wcmatch==8.4.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 52)) (8.4.1)
Requirement already satisfied: websocket-client==1.6.1 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 53)) (1.6.1)
Requirement already satisfied: yamllint==1.32.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from -r requirements.txt (line 54)) (1.32.0)
Requirement already satisfied: typing-extensions>=4.5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-compat==4.1.2->-r requirements.txt (line 1)) (4.7.1)
Requirement already satisfied: importlib-resources<5.1,>=5.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from ansible-core==2.15.1->-r requirements.txt (line 2)) (5.0.7)
Requirement already satisfied: tomli>=1.1.0 in ./.tox/py39-ansible30/lib/python3.9/site-packages (from black==23.7.0->-r requirements.txt (line 7)) (2.0.1)
WARNING: You are using pip version 22.0.4; however, version 23.2 is available.
You should consider upgrading via the '/opt/vector-role/.tox/py39-ansible30/bin/python -m pip install --upgrade pip' command.
py39-ansible30 run-test: commands[1] | molecule test -s podman
WARNING  Driver podman does not provide a schema.
INFO     podman scenario test matrix: dependency, cleanup, destroy, syntax, create, prepare, converge, idempotence, side_effect, verify, cleanup, destroy
INFO     Performing prerun with role_name_check=0...
INFO     Set ANSIBLE_LIBRARY=/root/.cache/ansible-compat/f5bcd7/modules:/root/.ansible/plugins/modules:/usr/share/ansible/plugins/modules
INFO     Set ANSIBLE_COLLECTIONS_PATH=/root/.cache/ansible-compat/f5bcd7/collections:/root/.ansible/collections:/usr/share/ansible/collections
INFO     Set ANSIBLE_ROLES_PATH=/root/.cache/ansible-compat/f5bcd7/roles:/root/.ansible/roles:/usr/share/ansible/roles:/etc/ansible/roles
INFO     Using /root/.cache/ansible-compat/f5bcd7/roles/chashkov.vector symlink to current repository in order to enable Ansible to find the role using its expected full name.
INFO     Running podman > dependency
WARNING  Skipping, missing the requirements file.
WARNING  Skipping, missing the requirements file.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy
INFO     Sanity checks: 'podman'

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j670248066252.10552', 'results_file': '/root/.ansible_async/j670248066252.10552', 'changed': True, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

TASK [Delete podman network dedicated to this scenario] ************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > syntax

playbook: /opt/vector-role/molecule/podman/converge.yml
INFO     Running podman > create

PLAY [Create] ******************************************************************

TASK [Get podman executable path] **********************************************
ok: [localhost]

TASK [Register podman executable path] *****************************************
ok: [localhost]

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Log into a container registry] *******************************************
skipping: [localhost] => (item="centos7 registry username: None specified") 
skipping: [localhost]

TASK [Check presence of custom Dockerfiles] ************************************
ok: [localhost] => (item=Dockerfile: None specified)

TASK [Create Dockerfiles from image names] *************************************
skipping: [localhost] => (item="Dockerfile: None specified; Image: docker.io/pycontribs/centos:7") 
skipping: [localhost]

TASK [Discover local Podman images] ********************************************
ok: [localhost] => (item=centos7)

TASK [Build an Ansible compatible image] ***************************************
skipping: [localhost] => (item=docker.io/pycontribs/centos:7) 
skipping: [localhost]

TASK [Determine the CMD directives] ********************************************
ok: [localhost] => (item="centos7 command: None specified")

TASK [Remove possible pre-existing containers] *********************************
changed: [localhost]

TASK [Discover local podman networks] ******************************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

TASK [Create podman network dedicated to this scenario] ************************
skipping: [localhost]

TASK [Create molecule instance(s)] *********************************************
changed: [localhost] => (item=centos7)

TASK [Wait for instance(s) creation to complete] *******************************
changed: [localhost] => (item=centos7)

PLAY RECAP *********************************************************************
localhost                  : ok=9    changed=3    unreachable=0    failed=0    skipped=5    rescued=0    ignored=0

INFO     Running podman > prepare
WARNING  Skipping, prepare playbook not configured.
INFO     Running podman > converge

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
changed: [centos7]

TASK [vector-role : Vector | Install package] **********************************
changed: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
changed: [centos7]

TASK [vector-role : Vector | Register service] *********************************
changed: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=4    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Running podman > idempotence

PLAY [Converge] ****************************************************************

TASK [Gathering Facts] *********************************************************
ok: [centos7]

TASK [Include vector-role] *****************************************************

TASK [vector-role : Include tasks install CentOS] ******************************
included: /opt/vector-role/tasks/install/CentOS.yml for centos7

TASK [vector-role : Vector | Download rpm] *************************************
ok: [centos7]

TASK [vector-role : Vector | Install package] **********************************
ok: [centos7]

TASK [vector-role : Include tasks install Ubuntu] ******************************
skipping: [centos7]

TASK [vector-role : Vector | Create data dir] **********************************
ok: [centos7]

TASK [vector-role : Vector | Template config] **********************************
ok: [centos7]

TASK [vector-role : Vector | Register service] *********************************
ok: [centos7]

PLAY RECAP *********************************************************************
centos7                    : ok=7    changed=0    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Idempotence completed successfully.
INFO     Running podman > side_effect
WARNING  Skipping, side effect playbook not configured.
INFO     Running podman > verify
INFO     Running Ansible Verifier

PLAY [Verify] ******************************************************************

TASK [Example assertion] *******************************************************
ok: [centos7] => {
    "changed": false,
    "msg": "All assertions passed"
}

PLAY RECAP *********************************************************************
centos7                    : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

INFO     Verifier completed successfully.
INFO     Running podman > cleanup
WARNING  Skipping, cleanup playbook not configured.
INFO     Running podman > destroy

PLAY [Destroy] *****************************************************************

TASK [Set async_dir for HOME env] **********************************************
ok: [localhost]

TASK [Destroy molecule instance(s)] ********************************************
changed: [localhost] => (item={'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True})

TASK [Wait for instance(s) deletion to complete] *******************************
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (300 retries left).
FAILED - RETRYING: [localhost]: Wait for instance(s) deletion to complete (299 retries left).
changed: [localhost] => (item={'failed': 0, 'started': 1, 'finished': 0, 'ansible_job_id': 'j263476267516.13733', 'results_file': '/root/.ansible_async/j263476267516.13733', 'changed': True, 'item': {'hostname': 'centos7', 'image': 'docker.io/pycontribs/centos:7', 'name': 'centos7', 'pre_build_image': True}, 'ansible_loop_var': 'item'})

TASK [Delete podman network dedicated to this scenario] ************************
skipping: [localhost] => (item=centos7: None specified) 
skipping: [localhost]

PLAY RECAP *********************************************************************
localhost                  : ok=3    changed=2    unreachable=0    failed=0    skipped=1    rescued=0    ignored=0

INFO     Pruning extra files from scenario ephemeral directory
__________________________________________________________________________ summary ___________________________________________________________________________
  py37-ansible210: commands succeeded
  py37-ansible30: commands succeeded
  py39-ansible210: commands succeeded
  py39-ansible30: commands succeeded
  congratulations :) 
```

</details>

2.6. Добавлен новый тэг 1.2.0 (т.к. расширение функционала без потери обратной совместимости) 