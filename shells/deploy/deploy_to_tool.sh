#!/bin/bash

WORKROOT=$(cd $(dirname $0);pwd)
TAGNAME="tool-platform"

for host in $($WORKROOT/get_clone_servers.sh $TAGNAME); do
  host=`echo "$host" | sed s/\"//g`
  echo " **** start RSYNC TO $host"
  echo $host >&2

  rsync -avz --delete -e "ssh -p 22" \
    --exclude='*/.git' \
    /home/ec2-user/projects ec2-user@$host:/home/ec2-user
  echo >&2
done
