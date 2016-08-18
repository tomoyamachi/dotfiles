#!/bin/bash
if [ $# -ne 1 ]
then
	echo フェスタのidを指定してください
	exit;
fi
PROJ="/home/amachi/newtrunk"

pf_count_array=( '2' '3' '4' )
for pf_count in  ${pf_count_array[@]};do
    mkdir -p $PROJ/share/www/img/public/img/feature/festa/$1/$pf_count
    mkdir -p $PROJ/share/www/bkrs2/resource/flash/festa/$1/$pf_count
    mkdir -p $PROJ/share/www/bkrs2/application/modules/main/views/scripts/gimmick/html/festa/$1/$pf_count
done
