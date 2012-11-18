#!/bin/bash
if [ $# -ne 1 ]
then
	echo feature_idを指定してください
	exit;
fi
PROJ="/home/amachi/newtrunk"
mkdir $PROJ/share/www/bkrs2/resource/feature_star/$1
mkdir $PROJ/share/www/bkrs2/resource/feature_star/$1/flash
