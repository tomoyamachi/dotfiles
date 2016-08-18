<?php
date_default_timezone_set('Asia/Tokyo');
$yesterday = date('Ymd', strtotime('-1 day'));
$sql = "SELECT account_id,count(account_id) AS cnt FROM [gochiplatform:accounts_response_log_with_account_id.v2_accounts_param_sms_${yesterday}] WHERE request_method = 'PUT' GROUP BY account_id;";

$result = shell_exec("/home/ec2-user/data/google-cloud-sdk/bin/bq query --format=json \"$sql\"");
$lines = preg_split( "%[\r\n]+%", $result );

// bqコマンド実行時にWaiting on bqjob_.... という文字列がでるので、json文字列だけ取得
foreach ($lines as $line) {
    $smsInputData = json_decode($line, true);
    if ($smsInputData) {
        break;
    }
}


$threshold = 5;
$txt = '';
foreach ($smsInputData as $data) {
    if ($data['cnt'] > $threshold) {
        $txt .= sprintf('account_id : %d input sms code %d times', $data['account_id'], $data['cnt'])."\n";
    }
}

if ($txt !== '') {
    $headers = [
        'MIME-Version: 1.0',
        'From: SMS input counter<ec2-user@gochipon.com>',
    ];

    $yesterdayTitle = date('Y/m/d', strtotime('-1 day'));
    $subject = "[Alert] $yesterdayTitle SMS送信回数";
    mail('accounts.platform@gochipon.co.jp', $subject, $txt, implode("\r\n", $headers));
}
