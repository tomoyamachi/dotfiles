#!/bin/bash

WORKROOT=$(cd $(dirname $0);pwd)

# デプロイしたいプロジェクトを指定
if [ "$1" ]; then
    PROJNAME=$1
    shift
else
    echo "deployしたいプロジェクト名を入れてください。"
    read PROJNAME
fi

if [ "$PROJNAME" ]; then
    echo "プロジェクト名 : $PROJNAME"
else
    echo "不正な文字列です"
    exit 1
fi


# デプロイしたい環境を指定 (prod, stage)
if [ "$1" ]; then
    ENV=$1
    shift
else
    echo "deployしたい環境を入れてください。(prod||stage)"
    read ENV
fi

if [ "$ENV" ]; then
    echo "環境 : $ENV"
else
    echo "不正な文字列です"
    exit 1
fi

# タグ名を検索
TAGNAME=$PROJNAME-$ENV

# オプションの確認
OPT=
while getopts y: OPT
do
    case $OPT in
        y) YES_OR_NO=y ;;
        \?) echo "deploy_to_clon.sh プロジェクト名 環境" 1>&2
            exit 1 ;;
    esac
done

if [ "$YES_OR_NO" = "y" ]; then
    echo '同期を実行します'
else
    echo "deploy先サーバのタグ名は 「$TAGNAME」です。よろしいですか？(y)"
    read YES_OR_NO
    if [ "$YES_OR_NO" = "y" ]; then
        echo '同期を実行します'
    else
        echo '終了します'
        exit 1
    fi
fi


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
