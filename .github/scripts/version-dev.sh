#!/bin/bash

# Always resolve script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

VERSION_FILE="$REPO_ROOT/.version_dev"
DATE_FILE="$REPO_ROOT/.version_dev_date"

if [ -f "$VERSION_FILE" ]; then
  current_version=$(cat "$VERSION_FILE")
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
  last_year=$(cut -d'-' -f1 "$DATE_FILE")
  last_month=$(cut -d'-' -f2 "$DATE_FILE")
else
  last_year=$current_year
  last_month=$current_month
fi

increment_version() {
  case $1 in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac

  new_version="$major.$minor.$patch"
  echo "$new_version" > "$VERSION_FILE"
  echo "$current_year-$current_month" > "$DATE_FILE"

  # Only export to GitHub Actions if GITHUB_ENV is set
  if [ -n "$GITHUB_ENV" ]; then
    echo "NEW_VERSION=$new_version" >> "$GITHUB_ENV"
  fi

  echo "✅ New version generated: $new_version"
}

if [ "$current_year" -gt "$last_year" ]; then
  increment_version "major"
elif [ "$current_month" -gt "$last_month" ]; then
  increment_version "minor"
else
  increment_version "patch"
fi
