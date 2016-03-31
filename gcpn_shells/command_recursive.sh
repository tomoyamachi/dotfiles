#!/bin/sh
# 対象のフォルダに再帰的にコマンドを実行
# .git内のファイルは除く
if [ "$1" ]; then
    TARGET_DIR=$1
else
    echo "対象のディレクトリを指定してください"
    exit 1
fi

if [ "$2" ]; then
    COMMAND=$2
else
    echo "コマンドを指定してください"
    exit 1
fi

echo $COMMAND
if [ "$3" ]; then
    echo "コマンドはクオートで囲ってください。第3引数は存在しません。。"
    exit 1
fi

find $TARGET_DIR \( -name ".git" \) -prune -o -type f | while read FILE; do
    echo "$COMMAND $FILE"
    eval "$COMMAND $FILE"
done
