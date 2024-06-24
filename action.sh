#!/bin/bash

set -e

REPO_NAME=$1

# Replace "my-template" with the new repository name in all files
find . -type f -exec sed -i '' "s/abcd/$REPO_NAME/g" {} +

# Delete the .github folder
#if [ -d ".github" ]; then
#  rm -rf .github
#fi

# Commit changes
git config --local user.email "actions@github.com"
git config --local user.name "GitHub Actions"
git add .
git commit -m "Replace 'my-template' with '$REPO_NAME' and delete .github folder"
git push origin main

echo "Action completed successfully!"
