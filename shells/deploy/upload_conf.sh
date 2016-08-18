#!/bin/sh
# configファイルを各環境にアップロード

WORKROOT=$(cd $(dirname $0);pwd)
PROJECT=$1

sudo cp /home/ec2-user/conf/nginx/$PROJECT.conf /etc/nginx/conf.d/
sudo cp /home/ec2-user/conf/nginx/apc-clear.conf /etc/nginx/conf.d/
sudo service nginx restart


sudo cp /home/ec2-user/conf/td-agent/td_agent_clone.conf /etc/td-agent/td-agent.conf
sudo service td-agent restart
