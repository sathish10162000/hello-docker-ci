#!/bin/bash
set -e

# Get current version
version=$(cat .version)

# Split version into major, minor, patch
IFS='.' read -r major minor patch <<< "$version"

# Increment patch
patch=$((patch + 1))

# New version
new_version="${major}.${minor}.${patch}"

# Save to file
echo "$new_version" > .version

# Export to GitHub Actions output
echo "new_version=$new_version" >> $GITHUB_OUTPUT

