# Домашнее задание к занятию 7 «Жизненный цикл ПО»

## Подготовка к выполнению

1. Получить бесплатную версию [Jira](https://www.atlassian.com/ru/software/jira/free).
2. Настроить её для своей команды разработки.
3. Создать доски Kanban и Scrum.

## Основная часть

Необходимо создать собственные workflow для двух типов задач: bug и остальные типы задач. Задачи типа bug должны проходить жизненный цикл:

1. Open -> On reproduce.
2. On reproduce -> Open, Done reproduce.
3. Done reproduce -> On fix.
4. On fix -> On reproduce, Done fix.
5. Done fix -> On test.
6. On test -> On fix, Done.
7. Done -> Closed, Open.

Остальные задачи должны проходить по упрощённому workflow:

1. Open -> On develop.
2. On develop -> Open, Done develop.
3. Done develop -> On test.
4. On test -> On develop, Done.
5. Done -> Closed, Open.

**Что нужно сделать**

1. Создайте задачу с типом bug, попытайтесь провести его по всему workflow до Done. 
1. Создайте задачу с типом epic, к ней привяжите несколько задач с типом task, проведите их по всему workflow до Done. 
1. При проведении обеих задач по статусам используйте kanban. 
1. Верните задачи в статус Open.
1. Перейдите в Scrum, запланируйте новый спринт, состоящий из задач эпика и одного бага, стартуйте спринт, проведите задачи до состояния Closed. Закройте спринт.
2. Если всё отработалось в рамках ожидания — выгрузите схемы workflow для импорта в XML. Файлы с workflow и скриншоты workflow приложите к решению задания.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

# Решение

XML файлы с процессами в директории ./workflows

Общая схема процесса

<img src="./img/3.png">

Схема процесса bug

<img src="./img/1.png">

Схема процесса common

<img src="./img/2.png">

Доска Kanban

<img src="./img/4.png">

Прохождение процесса для bug и task

<img src="./img/5.png">
<img src="./img/6.png">
<img src="./img/7.png">
<img src="./img/8.png">
<img src="./img/9.png">

Доска Scrum и планирование спринта

<img src="./img/12.png">
<img src="./img/10.png">
<img src="./img/11.png">

Прохождение процесса для задач по Scrum

<img src="./img/12.png">
<img src="./img/13.png">
<img src="./img/14.png">
<img src="./img/15.png">
<img src="./img/16.png">

Закрытие спринта

<img src="./img/17.png">