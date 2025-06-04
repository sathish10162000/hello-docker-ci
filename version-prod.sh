#!/bin/bash

VERSION_FILE=".version_prod"
DATE_FILE=".version_date"

# Read current version or default
if [ -f "$VERSION_FILE" ]; then
  current_version=$(cat $VERSION_FILE)
else
  current_version="0.0.0"
fi

IFS='.' read -ra parts <<< "$current_version"
major=${parts[0]:-0}
minor=${parts[1]:-0}
patch=${parts[2]:-0}

# Date
current_month=$(date +"%m")
current_year=$(date +"%Y")

if [ -f "$DATE_FILE" ]; then
  last_year=$(cut -d'-' -f1 $DATE_FILE)
  last_month=$(cut -d'-' -f2 $DATE_FILE)
else
  last_year=$current_year
  last_month=$current_month
fi

# Increment logic
if [ "$current_year" -gt "$last_year" ]; then
  ((major++)); minor=0; patch=0
elif [ "$current_month" -gt "$last_month" ]; then
  ((minor++)); patch=0
else
  ((patch++))
fi

new_version="$major.$minor.$patch"
echo "$new_version" > $VERSION_FILE
echo "$current_year-$current_month" > $DATE_FILE
echo "NEW_VERSION=$new_version" >> $GITHUB_ENV
