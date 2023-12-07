#!/bin/bash

cd /repo
# Check if a folder name is provided
if [ "$1" ]; then
    cd "$1"
fi

# Run the analysis scripts
/usr/local/bin/churn_vs_complexity.sh

# Start the web server
cd /var/www
python -m http.server 8000
