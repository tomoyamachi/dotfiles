#!/bin/bash
# cifeature.sh "�R�����g��"
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

    str=`svn st $PROJ/bin/bkrs2/master/image/ | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`
    str="$str `svn st $PROJ/share/www/bkrs2/resource/ | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`"
    str="$str `svn st $PROJ/share/www/bkrs2/public/inline/in_myrstn | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`"
    str="$str `svn st $PROJ/share/www/bkrs2-turbine/resource/myrstn | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`"
    str="$str `svn st $PROJ/share/www/img/public/img | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`"
    str="$str `svn st $PROJ/share/www/img/public/img-sp | grep -vE "php" | sed -e s/"^.[ ]*\+?"//`"
    str="$str `svn st $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html | grep -vE "php" | sed -e s/"^.[ ]*"//`"

    str=`echo $str | sed 's/^ *//g'`
    echo $str
    if [ -n "$str" ];then
        echo 'commited!!'
        svn ci -m "$1" $str
    else
        echo '�R�~�b�g����t�@�C��������܂���ł���'
    fi
else
    echo "�R�~�b�g�R�����g����͂��Ă�������"
    exit 1
fi
