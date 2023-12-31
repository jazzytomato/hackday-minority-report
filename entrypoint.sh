#!/bin/bash

cd /repo
# Check if a folder name is provided
if [ "$1" ]; then
    cd "$1"
fi

# Vars
PROJECT_NAME="$(basename -s .git `git config --get remote.origin.url`) - $1"

# Subs
sed -i "s/{{PROJECT_NAME}}/$PROJECT_NAME/" /var/www/index.html

echo "Running analysis for $PROJECT_NAME"
/usr/local/bin/churn_vs_complexity.sh
/usr/local/bin/coupling.sh

echo "Starting web server..."
cd /var/www
python3 -m http.server 8000
