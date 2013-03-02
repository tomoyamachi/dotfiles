WORKROOT=$(cd $(dirname $0);pwd)
cd $WORKROOT

#!/bin/sh
if [ $# -ne 2 ]; then
    echo "usage  :  replace_conf.sh {platform} {username}"
    exit
fi

### 指定されたユーザー名が指定されたものにあるかチェック
user_array=( 'amachi' 'fukui' 'twatanabe' 'furugaki' )
user_name=
for valid_name in  ${user_array[@]};do
    if [[ $2 = $valid_name ]];then
        user_name=$valid_name
        break
    fi
done

if [[ $user_name ]];then
    echo $user_name
else
    echo 'invalid user name!!'
    exit
fi
### ユーザー名チェック終わり
platform=$1

export current_conf_file='./bkrs2-dev.conf'
export temp_conf_file='./tmp.conf'


#perl呼び出し
perl ./replace_conf.pl $platform $user_name
/etc/init.d/httpd configtest

mv $temp_conf_file $current_conf_file
