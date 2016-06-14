#!/bin/bash

# 独自ドメイン
WORKROOT=$(cd $(dirname $0);pwd)

declare -A domains

# key : target domain, value : elb-name
# 本番環境
# domains["api.accounts.platform.gochipon.com"]="gochipon-api"
# domains["api.products.platform.gochipon.com"]="product-api"
# domains["api.localinfos.platform.gochipon.com"]="localinfos-api"
# domains["tool.accounts.platform.gochipon.com"]="none"
# domains["tool.products.platform.gochipon.com"]="none"
# domains["tool.localinfos.platform.gochipon.com"]="none"

# staging環境
domains["api.accounts.stage.gochipon.com"]="none"
domains["api.products.stage.gochipon.com"]="none"
domains["tool.accounts.stage.gochipon.com"]="none"
domains["tool.products.stage.gochipon.com"]="none"

for DOMAINNAME in "${!domains[@]}"; do
    echo $DOMAINNAME
    cd $WORKROOT && ./get_domains_cert.sh $DOMAINNAME && ./elb_upload_letsencrypt_cert.sh $DOMAINNAME ${domains[$DOMAINNAME]}
done
