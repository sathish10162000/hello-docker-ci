#!/bin/bash

VERSION_FILE=".version_dev"
DATE_FILE=".version_dev_date"

if [ -f "$VERSION_FILE" ]; then
  current_version=$(cat $VERSION_FILE)
else
  current_version="0.0.0"
fi

IFS='.' read -ra version_parts <<< "$current_version"
major=${version_parts[0]:-0}
minor=${version_parts[1]:-0}
patch=${version_parts[2]:-0}

current_month=$(date +"%m")
current_year=$(date +"%Y")

if [ -f "$DATE_FILE" ]; then
  last_year=$(cut -d'-' -f1 $DATE_FILE)
  last_month=$(cut -d'-' -f2 $DATE_FILE)
else
  last_year=$current_year
  last_month=$current_month
fi

increment_version() {
  case $1 in
    major)
      major=$((major + 1)); minor=0; patch=0;;
    minor)
      minor=$((minor + 1)); patch=0;;
    patch)
      patch=$((patch + 1));;
  esac

  new_version="$major.$minor.$patch"
  echo "$new_version" > "$VERSION_FILE"
  echo "$current_year-$current_month" > "$DATE_FILE"
}

# Decide how to increment
if [ "$current_year" -gt "$last_year" ]; then
  increment_version "major"
elif [ "$current_month" -gt "$last_month" ]; then
  increment_version "minor"
else
  increment_version "patch"
fi

new_version=$(cat "$VERSION_FILE")

# This is fine for logs
echo "New version: $new_version"

# ✅ This is correct format for GitHub Actions
echo "VERSION=$new_version" >> $GITHUB_ENV

# Output version string so step can use it if needed
echo "$new_version"
