#!/bin/sh

# following
# need install elasticdump

targets=(\
         'client_customer' \
             'client_company' \
             #'wt_history_call' \
             #'wt_history_common' \
             'wt_history_correspond' \
             'wt_history_document' \
             'wt_history_mail' \
             'wt_history_schedule'\
             'wt_history_slack'\
             'schedule_event'\
             'user'\
    );

for target in ${targets[@]}; do
    echo $target;
    elasticdump \
        --input=http://user:cYBPdA4cHMuF@35.200.42.100:9200/${target} \
        --output=/tmp/${target}.json
    curl -X DELETE http://localhost:9200/${target}/
    elasticdump \
        --input=/tmp/${target}.json \
        --output=http://localhost:9200/${target}
    echo;
done;

curl -XPOST http://localhost:9200/_aliases -d \
     '{
      "actions" : [
              { "add" : { "index" : "wt_history_call", "alias" : "worktable_history" } },
              { "add" : { "index" : "wt_history_correspond", "alias" : "worktable_history" } },
              { "add" : { "index" : "wt_history_document", "alias" : "worktable_history" } },
              { "add" : { "index" : "wt_history_mail", "alias" : "worktable_history" } },
              { "add" : { "index" : "wt_history_schedule", "alias" : "worktable_history" } },
              { "add" : { "index" : "wt_history_slack", "alias" : "worktable_history" } }
        ]
}'
