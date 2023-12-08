#!/bin/bash

echo "Analyzing Git history..."
git_log_output=$(git log --pretty=format: --name-only | sort | uniq -c | sort -rg)
echo "$git_log_output" | awk '{print $2, $1}' | sed 's|^backend/||' > /tmp/git_log_files.txt

echo "Running complexity analysis..."
complexity_output=$(complexity | sort -n --reverse)
echo "$complexity_output" | awk '{print $2, $1}' | sed 's|^./||' > /tmp/complexity_files.txt

# Combine the results and format as JSON
echo "[" > /var/www/churn_vs_complexity.json
awk 'FNR==NR {complexity[$1]=$2; next} {printf "{\"file\": \"%s\", \"churn\": %d, \"complexity\": %f},\n", $1, $2, complexity[$1]}' /tmp/complexity_files.txt /tmp/git_log_files.txt | sed '$ s/,$//' >> /var/www/churn_vs_complexity.json
echo "]" >> /var/www/churn_vs_complexity.json

