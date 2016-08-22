#!/bin/sh

###################
# サービスのプロジェクトを指定
if [ "$1" ]; then
    PROJNAME=$1
    shift
else
    echo "プロジェクト名を入れてください。"
    read PROJNAME
fi

if [ "$PROJNAME" ]; then
    echo "プロジェクト名 : $PROJNAME"
else
    echo "不正な文字列です"
    exit 1
fi

####################
# サービスの環境を指定 (prod, stage)
if [ "$1" ]; then
    ENV=$1
    shift
else
    echo "プロジェクトの環境を入れてください。(prod||stage)"
    read ENV
fi

if [ "$ENV" ]; then
    echo "環境 : $ENV"
else
    echo "不正な文字列です"
    exit 1
fi

# インスタンスのタグ名を保存
TAGNAME=$PROJNAME-$ENV


####################
# 最終確認を行う
# -y オプションでスキップ
FLAG=FALSE
while getopts y OPT; do
   case $OPT in
     y) FLAG=TRUE
        ;;
     \?) echo "Usage: $0 [-y]" 1>&2
         exit 1
         ;;
   esac
done

if [[ $FLAG = FALSE ]]; then
    echo "指定したタグ名は 「$TAGNAME」です。よろしいですか？(y)"
    read YES_OR_NO
    if [ "$YES_OR_NO" = "y" ]; then
        echo 'コマンドを実行します'
    else
        echo '終了します'
        exit 1
    fi
fi
