#!/bin/bash

VERSION_FILE=".version"

# If the version file does not exist, start with 0.0.1
if [ ! -f "$VERSION_FILE" ]; then
  echo "0.0.1" > "$VERSION_FILE"
fi

# Read current version
VERSION=$(cat $VERSION_FILE)

# Split version into major.minor.patch
IFS='.' read -r MAJOR MINOR PATCH <<< "$VERSION"

# Increment patch version
PATCH=$((PATCH + 1))

# Compose new version
NEW_VERSION="$MAJOR.$MINOR.$PATCH"

# Save new version to file
echo "$NEW_VERSION" > "$VERSION_FILE"

# Output version so GitHub Actions can use it
echo "$NEW_VERSION"
