# bash

Параметры скрипта

```bash
IFS=$' '                      # разделитель записей в лог файле
PIDFILE=/var/run/wlen.pid     # pid файл
LOGDIR=logs                   # директория с логами
LOGFILE=/var/log/wlen.log     # лог скрипта
recipient="vagrant@localhost" # получатель
XCOUNT=30                     # ограничение количества записей
YCOUNT=30      
```

Список IP адресов (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
```bash
awk -F" " '{print $1}' tarrascue_access.log | sort | uniq -c | sort -nr | head -20
```

Список запрашиваемых URL (с наибольшим кол-вом запросов) с указанием кол-ва запросов c момента последнего запуска скрипта;
```bash
awk -F" " '{print $7}' tarrascue_access.log | sort | uniq -c | sort -nr | head -20
```
Ошибки веб-сервера/приложения c момента последнего запуска;
```bash
cat tarrascue_error.log | grep "$errd"
```
Список всех кодов HTTP ответа с указанием их кол-ва с момента последнего запуска скрипта.
```bash
awk -F" " '{print $9}' tarrascue_access.log | sort | uniq -c | sort -nr
```
Добавляем фильтрацию по дате ($dacc), указание на логи ($LOGDIR) и количество записей ($COUNT):

```bash
cat $LOGDIR/tarrascue_access.log | grep "$dacc" | awk '{print $1}' | sort | uniq -c | sort -nr | head -$COUNT
```

Перед этим вычисляем дату, нужно что бы было 1 час назад:

```bash
dacc="`date -d '-1 hour' +'%d/%b/%Y:%H'`"
```
cron с условием запуска раз в час:
<pre>
* */1 * * *  root /bin/sh /bash.sh >/var/log/wlen.log 2>&1
</pre>
с перенаправлением лога самого скрипта в файл.


```
Content-Description: Undelivered Message
Content-Type: message/rfc822

Return-Path: <root@tarrascue.ru>
Received: by tarrascue.ru (Postfix, from userid 0)
        id 47FF988ADCF; Tue, 20 Jun 2023 11:00:52 +0300 (MSK)
Subject: hourly web server report
From: no-reply@localhost.ru
To: tarrascue@localhost.ru
Content-Type: text/plain
Message-Id: <20230620080052.47FF988ADCF@tarrascue.ru>
Date: Tue, 20 Jun 2023 11:00:52 +0300 (MSK)

>From the last hour there is some stats from web server

Report from 20/Jun/2023:10 to 20/Jun/2023:11.

We have some ip addresses:
count ip-address
20 20.208.47.239
 10 5.227.26.85
 1 193.32.87.40

and we have some urls:
count url
10 /
 1 /xmlrpc.php?rsd
 1 /wp/wp-includes/wlwmanifest.xml
 1 /wp-includes/wlwmanifest.xml
 1 /wp2/wp-includes/wlwmanifest.xml
 1 /wp1/wp-includes/wlwmanifest.xml
 1 /wordpress/wp-includes/wlwmanifest.xml
 1 /web/wp-includes/wlwmanifest.xml
 1 /website/wp-includes/wlwmanifest.xml
 1 /test/wp-includes/wlwmanifest.xml
 1 /sito/wp-includes/wlwmanifest.xml
 1 /site/wp-includes/wlwmanifest.xml
 1 /shop/wp-includes/wlwmanifest.xml
 1 /reg.html
 1 /news/wp-includes/wlwmanifest.xml
 1 /index.html
 1 /cms/wp-includes/wlwmanifest.xml
 1 /blog/wp-includes/wlwmanifest.xml
 1 /3rd.html
 1 /2nd.html
 1 /2020/wp-includes/wlwmanifest.xml
 1 /2019/wp-includes/wlwmanifest.xml

and we have some http codes:
count code
26 200
 5 304

We have some errors:



--47FF988ADCF.1687248052/tarrascue.ru--
```
