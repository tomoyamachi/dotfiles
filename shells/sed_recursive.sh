#!/bin/sh
# 対象のフォルダに再帰的にコマンドを実行
# .git内のファイルは除く


while getopts r: OPT
do
    case $OPT in
        r) run="$OPTARG" ;;
        \?) echo "Usage : -m 'コミットメッセージ' パス" 1>&2
            exit 1 ;;
    esac
done

if [ "$1" ]; then
    TARGET_DIR="$@"
else
    echo "対象のディレクトリを指定してください"
    exit 1
fi

echo "変換対象の文字列を指定してください"
read BEFORE
echo "変更後の文字列を指定してください"
read AFTER
echo "実際に変更しますか？(y)"
read YES_OR_NO


if [ "$YES_OR_NO" = "y" ]; then
    echo "変更を実行します\n"
    COMMAND="sed  -i -e \"s:$BEFORE:$AFTER:g\""
else
    echo "DRY RUNします\n"
    COMMAND="sed -e \"s/$BEFORE/$AFTER/g\""
fi

command_recursive.sh "$TARGET_DIR" "$COMMAND"
