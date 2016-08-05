#!/bin/bash
set -e
cd $(dirname $0)
WORKROOT=$(cd $(dirname $0);pwd)


now=`date -u "+%Y-%m-%dT%H:%M:%SZ"`
yesterday=`date -u -d "1 days ago" "+%Y-%m-%dT%H:%M:%SZ"`
yesterdayTitle=`date -u -d "1 days ago" "+%Y/%m/%d"`

start_time=${1:-$yesterday}
end_time=${2:-$now}
period=86400

# AWS PROFILE名
profiles=( 'aws+0001' 'aws+0002' 'aws+0003' 'aws+0004' 'aws+0005' 'aws+0006' 'aws+0007' 'aws+0008' 'aws+0009' 'aws+0010' )

# 地域

echo "To: aws@gochipon.co.jp"
echo "From: AWS Billing Info"
echo -e "Subject : $yesterdayTitle's Billing Info\n"


total_price=0
for profile in  ${profiles[@]};do
    echo "[$profile]"

    price=`aws --profile $profile \
              cloudwatch get-metric-statistics \
              --region us-east-1 \
              --namespace AWS/Billing \
              --metric-name EstimatedCharges \
              --start-time $start_time \
              --end-time $end_time \
              --period $period \
              --statistics "Maximum" \
              --dimensions Name=Currency,Value=USD | jq '.Datapoints | .[] | .Maximum'`

    if [ "$price" = "" ]; then
        price=0
    fi
    echo -e "\$ $price\n"

    total_price=$( echo $total_price+$price|bc -l )
done

# echo -e '*** TOTAL : '$total_price'$ ****'"\n"
