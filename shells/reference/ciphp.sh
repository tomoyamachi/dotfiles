#!/bin/bash

while getopts m: OPT
do
    case $OPT in
        m) message="$OPTARG" ;;
        \?) echo "Usage : -m 'コミットメッセージ' パス" 1>&2
            exit 1 ;;
    esac
done
# オプション部分を切り捨てる。
shift `expr $OPTIND - 1`

if [ "$1" ]; then
    path=$@
else
    path='./'
fi

if [ "$message" ]; then
    addstr=`svn st $path | grep -E '^\?' | sed -e s/"^?[ ]*"//`
    if [ $addstr ]; then
        svn add $addstr
    fi
    str=`svn st $path | grep -E "(php|phtml)" | sed -e s/"^.[ ]*"//`
    svn diff $str

    # syntax error がないかを確認
    for f in `$str  | grep -E "(php|phtml)" | sed -e s/"^.[ ]*"//`;do
        sudo php -l $f
    done

    # echo $str"をコミットしますか : "
    # read y
    # if [[ $y = 'y' ]]; then
    #     echo "svn ci -m $message `echo $str`"
    #     svn ci -m "$message" `echo $str`
    # fi

else
    echo "コミットコメントを入力してください"
    exit 1
fi
