#!/bin/sh

docker-compose exec mysql sh -c '
find /var/sql/ -name "*.sql" -prune -o -type f | while read FILE; do
    mysql -uroot -proot -Dbizshift < $FILE
done'
