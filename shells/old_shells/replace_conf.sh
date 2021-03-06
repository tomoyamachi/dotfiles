WORKROOT=$(cd $(dirname $0);pwd)
cd $WORKROOT

#!/bin/sh
if [ $# -lt 2 ]; then
    echo "usage  :  replace_conf.sh {platform} {username}"
    exit
fi

### 指定されたユーザー名が指定されたものにあるかチェック
if [[ $3 = 'production' ]];then
    user_array=( 'amachi' 'fukui' 'twatanabe' 'furugaki' 'mochizuki' )
else
    user_array=( 'kingnew' 'newtrunk' 'const' 'dgame' 'colopl' )
fi

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

if [[ $3 = 'production' ]];then
    export current_conf_file='/etc/httpd/conf.d/bkrs2-dev.conf'
    export temp_conf_file='/etc/httpd/conf.d/tmp.conf'
    #perl呼び出し
    perl ./replace_conf.pl $platform $user_name
else
    export current_conf_file='/etc/httpd/conf.d/bkrs2-dev-amachi2.conf'
    export temp_conf_file='/etc/httpd/conf.d/tmp.conf'
    #export current_conf_file='./bkrs2-dev-amachi2.conf'
    # export current_conf_file='./tmp.conf'
    # export temp_conf_file='./tmp2.conf'
    perl ./replace_branch_conf.pl $platform $user_name
fi


/etc/init.d/httpd configtest

mv $temp_conf_file $current_conf_file
