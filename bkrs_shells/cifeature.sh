#!/bin/bash
# cifeature.sh "コメント名"
if [ "$1" ]; then
    PROJ="/home/amachi/newtrunk"
    addstr=`svn st $PROJ/bin/bkrs2/master/image/ | grep -E '^\?' | sed -e s/"^?[ ]*"//`
    addstr="$addstr `svn st $PROJ/share/www/bkrs2/resource/ | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/bkrs2/public/inline/in_myrstn | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/bkrs2-turbine/resource/myrstn | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/img/public/img | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/img/public/img-sp | grep -E '^\?' | sed -e s/"^?[ ]*"//`"
    addstr="$addstr `svn st $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html | grep -E '^\?' | sed -e s/"^?[ ]*"//`"

    addstr=`echo $addstr | sed 's/^ *//g'`
    if [ -n "$addstr" ];then
        svn add $addstr
    fi

    str=`svn st $PROJ/bin/bkrs2/master/image/ | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`
    str="$str `svn st $PROJ/share/www/bkrs2/resource/ | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`"
    str="$str `svn st $PROJ/share/www/bkrs2/public/inline/in_myrstn | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`"
    str="$str `svn st $PROJ/share/www/bkrs2-turbine/resource/myrstn | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`"
    str="$str `svn st $PROJ/share/www/img/public/img | grep -vE "php"  | perl -nle 's/.\s*\+?//;print $_'`"
    str="$str `svn st $PROJ/share/www/img/public/img-sp | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`"
    str="$str `svn st $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html | grep -vE "php" | perl -nle 's/.\s*\+?//;print $_'`"

    str=`echo $str | sed 's/^ *//g'`
    echo $str
    if [ -n "$str" ];then
        echo 'commited!!'
        svn ci -m "$1" $str
    else
        echo 'コミットするファイルがありませんでした'
    fi
else
    echo "コミットコメントを入力してください"
    exit 1
fi
