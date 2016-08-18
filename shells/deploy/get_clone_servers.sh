#!/bin/bash

if [ "$1" ]; then
    TAGNAME=$1
else
    echo "デプロイしたいAutoScailingServerのTag : Nameのvalueを入れてください"
    exit 1
fi
aws ec2 describe-instances --filters "Name=tag:Name,Values=$TAGNAME"| jq '.Reservations | .[]' | jq '.Instances | .[]' | jq '.PrivateIpAddress'
