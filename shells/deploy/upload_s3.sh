#!/bin/sh
BUCKET=log.platform.gochipon.com
echo $@ >> /tmp/upload_s3.txt
for LOGFILE in $@; do
    # 3世代前に残したログをアップロード
    # logrotateの設定で2世代前のものまでgzip圧縮されており、
    # 本スクリプトはpostrotateで読み込まれるので、3時間前のものがgzip圧縮されている
    LOGFILE=$LOGFILE-`date '+%Y%m%d%H' -d '3hours ago'`.gz
    BUCKETPATH=`echo "$LOGFILE" | sed s:/home/ec2-user/var/log/fluentd/::g`

    echo `whoami` >> /tmp/whoami.txt
    echo $LOGFILE >> /tmp/upload_s3_logfile.txt
    echo $BUCKETPATH >> /tmp/upload_s3_bucketpath.txt

    # mime-typeは未設定
    echo $LOGFILE
    echo $BUCKETPATH
    /usr/bin/s3cmd -M put $LOGFILE s3://${BUCKET}/${BUCKETPATH}

    # htmlで指定するとダウンロード後にunzipできなくなる
    #/usr/bin/s3cmd  -m text/html --add-header='Content-Encoding: gzip' put $LOGFILE s3://${BUCKET}/${BUCKETPATH}
done
