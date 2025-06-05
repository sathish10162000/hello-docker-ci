#!/bin/bash

VERSION_FILE=".version"

# If version file doesn't exist, start at 0.0.1
if [ ! -f "$VERSION_FILE" ]; then
  echo "0.0.1" > "$VERSION_FILE"
fi

# Read and split version
VERSION=$(cat $VERSION_FILE)
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# Increment patch
PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Save new version
echo "$NEW_VERSION" > "$VERSION_FILE"

# Print to GitHub Actions
echo "VERSION=$NEW_VERSION" >> $GITHUB_ENV
