#!/bin/sh
# .emacs.d/.cache
# .git内のファイルは除く
EMACS_PROCESS=`ps -ex | grep [E]macs`;
if [ -n "$EMACS_PROCESS" ];then
    echo "Emacsプロセスが起動しています。killしていいですか? (y/n)"
    read YES_OR_NO
    if [ "$YES_OR_NO" = "y" ]; then
        killall "Emacs"
    else
        echo "プロセスをkillして再度実行してください。"
        exit 0;
    fi
else
    echo "No Emacs process"
fi
sed_recursive.sh "$HOME/dotfiles/.emacs.d/.cache"


