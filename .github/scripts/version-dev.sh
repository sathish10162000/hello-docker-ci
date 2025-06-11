#!/bin/bash
set -e

VERSION_FILE=".version_dev"
current_version=$(cat $VERSION_FILE)

IFS='.' read -r major minor patch <<< "$current_version"
patch=$((patch + 1))
new_version="${major}.${minor}.${patch}"

echo "$new_version" > "$VERSION_FILE"

# Export for GitHub Actions
if [ -n "$GITHUB_ENV" ]; then
  echo "NEW_VERSION=$new_version" >> "$GITHUB_ENV"
fi

echo "✅ New version: $new_version"
