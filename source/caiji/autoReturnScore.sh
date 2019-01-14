#!/bin/bash

cd /home/www/caipiao/caiji

PROC_NAME="autoReturnScore"
ProcNumber=`ps -ef |grep -w $PROC_NAME|grep -v grep|wc -l` 
if [ $ProcNumber -le 0 ];then 
	/usr/bin/php autoReturnScore.php >/dev/null 2>&1 &
fi 










