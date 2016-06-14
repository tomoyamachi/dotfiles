#!/bin/sh
# configファイルを各環境にコピー
#TAGNAMES=('product-api-prod' 'account-api-prod' 'localinfo-api-prod' 'product-api-stage' 'account-api-stage' 'localinfo-api-stage')


WORKROOT=$(cd $(dirname $0);pwd)

source $WORKROOT/get_target_tag.sh

# 各環境のconfigを同期 (scp)
CONF_FILE_DIR=/home/ec2-user/conf
BIN_FILE_DIR=/home/ec2-user/bin


for host in $($WORKROOT/get_clone_servers.sh $TAGNAME); do
  host=`echo "$host" | sed s/\"//g`
  echo $host >&2

  # confファイルを同期
  rsync -avz --delete -e "ssh -p 22" \
    --exclude='*/.git' \
    $CONF_FILE_DIR ec2-user@$host:/home/ec2-user
  echo >&2


  rsync -avz --delete -e "ssh -p 22" \
    --exclude='*/.git' \
    $BIN_FILE_DIR ec2-user@$host:/home/ec2-user
  echo >&2


  ssh -t -t ec2-user@$host /home/ec2-user/bin/upload_conf.sh $PROJNAME
  echo >&2

done
