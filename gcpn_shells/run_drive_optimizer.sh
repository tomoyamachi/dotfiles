#!/bin/sh
# spread sheetから最新の情報に更新し、必要な操作を実施する
while getopts h: OPT
do
    case $OPT in
        h)  echo "spread sheetのデータをプロジェクトに反映。Usage : run_drive_optimizer <project名> <書き込み先データベース名> <プロジェクトパス> \r プロジェクト名とプロジェクトパスが同じの場合、自動でホームディレクトリから対象のプロジェクトパスを選択" 1>&2 ;;
    esac
done
DRIVEROOT="${HOME}/drive_optimizer"
if [ "$1" ]; then
    for f in ${HOME}'/'${1}*
    do
        PROJECTROOT=$f
        break
    done
else
    if [ "$3" ]; then
        PROJECTROOT="$3"
    else
        echo 'Invalid Project Path'
        exit 1 ;;
    fi
fi

echo "driveからデータを更新"
php $DRIVEROOT/driveToData.php $1 $PROJECTROOT

echo "migrationファイル作成"
$PROJECTROOT/bin/gpl-task migration generate

echo "migrationファイルを実行"
$PROJECTROOT/bin/gpl-task migration run

echo "新しい構造用のモデルクラスを作成"
$PROJECTROOT/bin/gpl-task database generateClass

echo "初期データをSQLに保存"
mysql -uroot product_api < $PROJECTROOT/var/sql/*.sql

echo "完了しました"
