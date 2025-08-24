#!/bin/bash

# check if jq is installed
if ! command -v jq &> /dev/null; then
  echo "jq not found, installing..."
  if command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y jq
  elif command -v yum &> /dev/null; then
    sudo yum install -y jq
  elif command -v brew &> /dev/null; then
    brew install jq
  else
    echo "No known package manager found. Install jq manually."
    exit 1
  fi
fi

# merge all ./answers/*.json into one array
jq -s '[.[][]]' ./answers/*.json > merged.json

# check size (in bytes)
max_size=$((10 * 1024 * 1024)) # 10 MB
file_size=$(stat -c%s merged.json 2>/dev/null || stat -f%z merged.json)

if (( file_size > max_size )); then
  gzip -f merged.json
  echo "merged.json.gz created (was $file_size bytes)"
else
  echo "merged.json created (size $file_size bytes)"
fi
