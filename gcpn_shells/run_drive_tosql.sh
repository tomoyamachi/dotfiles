#!/bin/sh
# spread sheetから最新の情報に更新し、必要な操作を実施する
while getopts h: OPT
do
    case $OPT in
        h)  echo "spread sheetのデータをプロジェクトに反映。Usage : run_drive_optimizer <project名> <書き込み先データベース名> <プロジェクトパス> \r プロジェクト名とプ>ロジェクトパスが同じの場合、自動でホームディレクトリから対象のプロジェクトパスを選択" 1>&2 ;;
    esac
done
DRIVEROOT="${HOME}/drive_optimizer"

if [ "$3" ]; then
    PROJECTROOT="$3"
else
    if [ "$1" ]; then
        for f in ${HOME}'/'${1}*
        do
            PROJECTROOT=$f/
            break
        done
    else
        echo 'Invalid Project Path'
        exit 1
    fi
fi


echo "driveからデータを更新"
php $DRIVEROOT/export2sql.php $1 $PROJECTROOT

echo "CREATE TABLE"
find $PROJECTROOT/sql/ -name "*.sql" -prune -o -type f | while read FILE; do
    mysql -uroot $2 < $FILE
done

echo "初期データをSQLに保存"
find $PROJECTROOT/sql/data/ -name "*.sql" -prune -o -type f | while read FILE; do
    mysql -uroot $2 < $FILE
done


echo "完了しました"
