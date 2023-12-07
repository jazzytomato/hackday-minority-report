#!/bin/bash

git log --all --numstat --date=short --pretty=format:'--%h--%ad--%aN' --no-renames > /tmp/maat-logfile.log

java -jar /usr/local/bin/code-maat-1.0.4-standalone.jar -l /tmp/maat-logfile.log -c git2 -a coupling > /tmp/maat-coupling.txt


echo "[" > /var/www/coupling.json
tail -n +2 /tmp/maat-coupling.txt | while IFS=, read -r entity coupled degree avg_revs; do
    echo "{\"entity\": \"$entity\", \"coupled\": \"$coupled\", \"degree\": $degree, \"average_revs\": $avg_revs}," >> /var/www/coupling.json
done

sed -i '$ s/,$//' /var/www/coupling.json
echo "]" >> /var/www/coupling.json

# summary
java -jar /usr/local/bin/code-maat-1.0.4-standalone.jar -l /tmp/maat-logfile.log -c git2 -a summary > /tmp/maat-summary.txt

echo "{" > /var/www/summary.json
tail -n +2 /tmp/maat-summary.txt | while IFS=, read -r statistic value; do
    statistic=$(echo "$statistic" | xargs)
    value=$(echo "$value" | xargs)
    echo "\"$statistic\": $value," >> /var/www/summary.json
done
sed -i '$ s/,$/}/' /var/www/summary.json
