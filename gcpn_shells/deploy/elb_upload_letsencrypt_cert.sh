#!/bin/bash
## SSLの認証に成功した場合に呼び出されるはず
## 指定のELBに
cd $(dirname $0)

DOMAINNAME=$1
ELB_NAME=$2

# ELBが存在しなければ無視
if [[ $ELB_NAME -eq "none" ]]; then
    echo "This domain dont have Load Balancer"
    exit 1
fi

# 取得した証明書ファイルのリンク群が配置されるディレクトリ
# letsencrypt-auto に与えた最初のドメイン名が採用される
LE_FILES_ROOT=/etc/letsencrypt/live/$DOMAINNAME


# 現時点のサーバー証明書名リストを取得
OLD_SERVER_CERT_NAMES=$($EXEC_AWS iam list-server-certificates | jq -r ".ServerCertificateMetadataList[] | select(.ServerCertificateName | contains(\"${ELB_NAME}\")).ServerCertificateName")

# 証明書ファイル群のシンボリックリンクのパス
CERT_PATH=$LE_FILES_ROOT/cert.pem
CHAIN_PATH=$LE_FILES_ROOT/chain.pem
FULLCHAIN_PATH=$LE_FILES_ROOT/fullchain.pem
PRIVKEY_PATH=$LE_FILES_ROOT/privkey.pem

# 新しい証明書のサーバー証明書名
NEW_SERVER_CERT_NAME="${ELB_NAME}-${DATE_CURRENT_YMD}"

# 新しい証明書を IAM にアップロード
$EXEC_AWS iam upload-server-certificate --server-certificate-name $NEW_SERVER_CERT_NAME \
          --certificate-body file://$CERT_PATH \
          --private-key file://$PRIVKEY_PATH \
          --certificate-chain file://$CHAIN_PATH

# 反映を待つ
sleep 15

# 新しい証明書の ARN を取得
SERVER_CERT_ARN=$($EXEC_AWS iam list-server-certificates | jq -r ".ServerCertificateMetadataList[] | select(.ServerCertificateName == \"${NEW_SERVER_CERT_NAME}\").Arn")

# ELB に新しいサーバー証明書を設定
$EXEC_AWS elb set-load-balancer-listener-ssl-certificate \
          --load-balancer-name $ELB_NAME \
          --load-balancer-port 443 \
          --ssl-certificate-id $SERVER_CERT_ARN

# 反映を待つ
sleep 15

# 古い証明書を削除
for cert_name in $OLD_SERVER_CERT_NAMES; do
    $EXEC_AWS iam delete-server-certificate --server-certificate-name $cert_name
done
