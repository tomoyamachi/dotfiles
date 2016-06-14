#!/bin/bash

WORKROOT=$(cd $(dirname $0);pwd)
source $WORKROOT/get_target_tag.sh

CONF_FILE_DIR=/home/ec2-user/projects/config/$PROJNAME/$ENV

# 全体configファイルなどを同期
find $CONF_FILE_DIR/*.php | while read FILE; do
    echo " *** COPY FROM : "$FILE
    TARGETFILENAME=`echo "$FILE" | sed "s:$CONF_FILE_DIR::g"`
    if [[ "$ENV" = "prod" ]]; then
      # production環境の場合は、rsync対象のものに加える
      cp -a $FILE /home/ec2-user/projects/$PROJNAME/config/config.d/$TARGETFILENAME
    fi
    $WORKROOT/exec_to_clone_each.sh $TAGNAME cp -a $FILE /home/ec2-user/projects/$PROJNAME/config/config.d/$TARGETFILENAME &
done

wait

# 各環境のconfigを同期 (scp)
REPLACESTRING="$CONF_FILE_DIR/\(.*\)/config.php"
find $CONF_FILE_DIR/*/config.php | while read FILE; do
    TARGETDIR=`echo "$FILE" | sed "s:$REPLACESTRING:\1:g"`

    echo " **** COPY FROM :"$FILE", TO : $PROJNAME/app/$TARGETDIR/config/config.d/config.php"
    if [[ "$ENV" = "prod" ]]; then
      # production環境の場合は、rsync対象のものに加える
      cp -a $FILE /home/ec2-user/projects/$PROJNAME/app/$TARGETDIR/config/config.d/config.php
    fi

    $WORKROOT/exec_to_clone_each.sh $TAGNAME cp -a $FILE /home/ec2-user/projects/$PROJNAME/app/$TARGETDIR/config/config.d/config.php &
done

wait


for host in $($WORKROOT/get_clone_servers.sh $TAGNAME); do
  host=`echo "$host" | sed s/\"//g`
  echo " **** start RSYNC TO $host"
  echo $host >&2

  rsync -avz --delete -e "ssh -p 22" \
    --exclude='*/.git' \
    --exclude="/home/ec2-user/projects/$PROJNAME/*/config.php" \
    --exclude="/home/ec2-user/projects/$PROJNAME/*/database.php" \
    /home/ec2-user/projects/$PROJNAME ec2-user@$host:/home/ec2-user/projects
  echo >&2
done
