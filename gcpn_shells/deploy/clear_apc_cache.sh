#!/bin/bash

WORKROOT=$(cd $(dirname $0);pwd)
source $WORKROOT/get_target_tag.sh

get_public_ip(){
    aws ec2 describe-instances --filters "Name=tag:Name,Values=$TAGNAME"| jq '.Reservations | .[]' | jq '.Instances | .[]' | jq '.PublicIpAddress'
}

for host in `get_public_ip`; do
    host=`echo "$host" | sed s/\"//g`
    curl -X POST --data "token=password" $host/apc_clear.php
done
