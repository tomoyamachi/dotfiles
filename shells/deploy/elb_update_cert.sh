#!/bin/bash
set -e
cd $(dirname $0)
WORKROOT=$(cd $(dirname $0);pwd)

# 現在日付のYYYYMMDD
DATE_CURRENT_YMD=$(date '+%Y%m%d')

# AWS Profile 名
AWS_PROFILE=elb_update_cert

DOMAINNAME=$1
ELB_NAME=$2


# aws-cli 実行コマンド
EXEC_AWS="aws --profile ssl_uploader"

# Let's Encrypt の連絡用メールアドレス
LE_EMAIL=tomoya_amachi@gochipon.co.jp

# Let's Encrypt Client を clone したパス
LE_HOME=/var/letsencrypt

# letsencrypt-auto 実行コマンド
EXEC_LE_AUTO="${LE_HOME}/letsencrypt-auto --email $LE_EMAIL --agree-tos --debug"



# 取得した証明書ファイルのリンク群が配置されるディレクトリ
# letsencrypt-auto に与えた最初のドメイン名が採用される
LE_FILES_ROOT=/etc/letsencrypt/live/$DOMAINNAME


# LE_PARAM_DOMAINS="${LE_PARAM_DOMAINS[@]}"

# 証明書を(再)発行。
$EXEC_LE_AUTO certonly --webroot \
              --renew-by-default \
              -w /var/www/letsencrypt \
              -d $DOMAINNAME

# DOMAINが有効化
if [ $? = 1 ]; then
    echo "Invalid certificated domain : $DOMAINNAME"
    exit 1
fi


# ELBが存在しなければ無視
if [[ $ELB_NAME -eq "none" ]]; then
    echo "This domain dont have Load Balancer : $DOMAINNAME"
    exit 0
fi


cd $WORKROOT && ./elb_upload_letsencrypt_cert.sh $ELB_NAME
