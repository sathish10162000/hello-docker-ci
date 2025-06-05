#!/bin/bash

VERSION_FILE=".version_dev"
DATE_FILE=".version_dev_date"

# Get current version
if [ -f "$VERSION_FILE" ]; then
  current_version=$(cat $VERSION_FILE)
else
  current_version="0.0.0"
fi

IFS='.' read -ra parts <<< "$current_version"
major=${parts[0]:-0}
minor=${parts[1]:-0}
patch=${parts[2]:-0}

# Get current date
current_month=$(date +"%m")
current_year=$(date +"%Y")

# Get last version date
if [ -f "$DATE_FILE" ]; then
  last_year=$(cut -d'-' -f1 $DATE_FILE)
  last_month=$(cut -d'-' -f2 $DATE_FILE)
else
  last_year=$current_year
  last_month=$current_month
fi

# Bump logic
if [ "$current_year" -gt "$last_year" ]; then
  major=$((major + 1)); minor=0; patch=0
elif [ "$current_month" -gt "$last_month" ]; then
  minor=$((minor + 1)); patch=0
else
  patch=$((patch + 1))
fi

# Set new version
new_version="$major.$minor.$patch"
echo "$new_version" > "$VERSION_FILE"
echo "$current_year-$current_month" > "$DATE_FILE"

# ✅ Export for GitHub Actions
echo "VERSION=$new_version" >> $GITHUB_ENV

# ✅ Print version for logs
echo "$new_version"
