#!/bin/bash
if [ $# -ne 1 ]
then
	echo feature_id����ꤷ�Ƥ�������
	exit;
fi
PROJ="/home/amachi/newtrunk"
mkdir $PROJ/share/www/img/public/img/feature/$1
mkdir $PROJ/share/www/img/public/img-sp/feature/$1
