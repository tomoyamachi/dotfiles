#!/bin/bash

# 指定したタグ名のインスタンスに
# ""でかこった部分のコマンドを実行
# $ exec_to_clone.sh "command" project env

command=$1
shift

WORKROOT=$(cd $(dirname $0);pwd)
source $WORKROOT/get_target_tag.sh

for host in $(get_clone_servers.sh $TAGNAME); do
    host=`echo "$host" | sed s/\"//g`
    echo $command
    ssh -t -t ec2-user@$host $command &
done

wait
