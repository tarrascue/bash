#!/bin/bash
###############################
#                              #
# Web log email notify script #
#                              #
###############################
# config section

IFS=$' '
PIDFILE=/var/run/wlen.pid
LOGDIR=/var/log/nginx
LOGFILE=/var/log/wlen.log
recipient="tarrascue@localhost"
XCOUNT=30
YCOUNT=30

# date setup
hourago="`date -d '-1 hour' +'%d/%b/%Y:%H'`"
dlog="`date +"%d/%b/%Y %H:%M:%S"`"
datt="`date +"%d/%b/%Y:%H"`"
dacc="`date -d '-1 hour' +'%d/%b/%Y:%H'`"
derr="`date -d '-1 hour' +'%Y/%m/%d %H'`"
errd="`echo $derr | sed 's/-/\ /'`"

# functions
send_email()
{
        (
cat - <<END
Subject: hourly web server report
From: no-reply@localhost
To: $recipient
Content-Type: text/plain

From the last hour there is some stats from web server

Report from $dacc to $datt.

We have some ip addresses:
count ip-address
${IP_LIST[@]}

and we have some urls:
count url
${IP_ADDR[@]}

and we have some http codes:
count code
${HTTP_STATUS[@]}

We have some errors:
${ERRORS[@]}

END
) | /usr/sbin/sendmail $1
}

# here we start

if [ -e $PIDFILE ]
then
    echo "$dlog --> Script is running!" >> $LOGFILE 2>&1
    exit 1
else
        echo "$$" > $PIDFILE
        trap 'rm -f $PIDFILE; exit $?' INT TERM EXIT
        IP_LIST+=(`cat $LOGDIR/tarrascue_access.log | grep "$dacc" | awk '{print $1}' | sort | uniq -c | sort -nr | head -$XCOUNT`)
        IP_ADDR+=(`cat $LOGDIR/tarrascue_access.log | grep "$dacc" | awk '{print $7}' | sort | uniq -c | sort -nr | head -$YCOUNT`)
        HTTP_STATUS+=(`cat $LOGDIR/tarrascue_access.log | grep "$dacc" | awk '{print $9}' | sort | uniq -c | sort -nr`)
        ERRORS+=(`cat $LOGDIR/tarrascue.error.log | grep "$errd"`)
        send_email $recipient
        rm -r $PIDFILE
        trap - INT TERM EXIT
        echo "$dlog --> Success" >> $LOGFILE 2>&1
fi
