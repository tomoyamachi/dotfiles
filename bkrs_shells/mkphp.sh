#!/bin/bash
PROJ="/home/amachi/newtrunk"
cd $PROJ/bin/bkrs2/master/image

if [ $1 = 'food' ];then
    php mk_food.php
elif [ $1 = 'item' ]
then
    php mk_item.php
elif [ $1 = 'myrstn' ];then
    php mk_myrstn.php
fi

