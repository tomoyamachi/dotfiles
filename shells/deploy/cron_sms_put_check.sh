#!/bin/bash
set -e
cd $(dirname $0)
WORKROOT=$(cd $(dirname $0);pwd)

yesterday=`date -u "+%Y%m%d"`
yesterday="20160718"
yesterdayTitle=`date -u "+%Y/%m/%d"`



result=`php $WORKROOT/check_input_sms.php`
echo $?
if [ $? -ne "0" ];then
echo "To: tomoya_amachi@gochipon.co.jp"
echo "From: SMS input count"
echo -e "Subject : $yesterdayTitle's SMS input counts\n"

fi
