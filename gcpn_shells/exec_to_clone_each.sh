#!/bin/bash

#rm ~/.ssh/known_hosts

if [ "$1" ]; then
    TAGNAME=$1
else
    echo "デプロイしたいAutoScailingServerのTag : Nameのvalueを入れてください"
fi

shift
command=$@

for host in $(get_clone_servers.sh $TAGNAME); do
  host=`echo "$host" | sed s/\"//g`
  ssh -t -t ec2-user@$host $command &
done

wait
