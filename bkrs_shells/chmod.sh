#!/bin/bash
PROJ="/home/amachi/newtrunk"
if [ $# -ne 1 ]
then
    # 追加されたファイルはすべて766権限に書き換える
    cd $PROJ
    addstr=`svn st $PROJ/share/www/bkrs2/resource/ | grep -E '^\?' | sed -e s/"^?[ ]*"//`
    addstr="$addstr `svn st $PROJ/share/www/bkrs2/public/inline/in_myrstn | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/bkrs2-turbine/resource/myrstn | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/img/public/img | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/img/public/img-sp | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr=`echo $addstr | sed 's/^ *//g'`
    if [ -n "$addstr" ];then
        echo "change mod $addstr"
        chmod 777 $addstr
    fi
	echo feature_idを指定してください
	exit;
fi

if [ $1 = 'festa' ];then
    chmod -R 777 $PROJ/share/www/img/public/img/festa/
    chmod -R 777 $PROJ/share/www/bkrs2/resource/flash/festa/
    chmod -R 777 $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html/festa/
else
    chmod 766 $PROJ/share/www/img/public/img/mixer/$1/*
    chmod 766 $PROJ/share/www/img/public/img/feature/$1/*
    chmod 766 $PROJ/share/www/img/public/img-sp/feature/$1/*
    chmod 766 $PROJ/share/www/bkrs2/resource/frame/360/$1.png
    chmod 766 $PROJ/share/www/bkrs2/resource/back/360/$1.png
    chmod 766 $PROJ/share/www/bkrs2/resource/flash/gacha/*
    chmod 766 $PROJ/share/www/img/public/img/gacha/banner/gacha_$1_q.gif
    chmod 766 $PROJ/share/www/img/public/img/gacha/banner/gacha_$1_v.gif
    chmod 777 $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html/gacha/*
    kingdir="$PROJ/share/www/bkrs2/resource/king/$1"
    if [ -d "$kingdir" ]; then
        chmod 777 $kingdir/*
        chmod 777 $kingdir/flash/*
    fi

    stardir="$PROJ/share/www/bkrs2/resource/feature_star/$1"
    if [ -d "$stardir" ]; then
        chmod 777 $stardir/*
        chmod 777 $stardir/flash/*
    fi
fi