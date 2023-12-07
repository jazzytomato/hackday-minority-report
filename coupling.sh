#!/bin/bash

git log --all --numstat --date=short --pretty=format:'--%h--%ad--%aN' --no-renames > /tmp/maat-logfile.log

java -jar /usr/local/bin/code-maat-1.0.4-standalone.jar -l /tmp/maat-logfile.log -c git2 -a coupling > /tmp/maat-coupling.txt


echo "[" > /var/www/coupling.json
tail -n +2 /tmp/maat-coupling.txt | while IFS=, read -r entity coupled degree avg_revs; do
    echo "{\"entity\": \"$entity\", \"coupled\": \"$coupled\", \"degree\": $degree, \"average_revs\": $avg_revs}," >> /var/www/coupling.json
done

sed -i '$ s/,$//' /var/www/coupling.json
echo "]" >> /var/www/coupling.json
