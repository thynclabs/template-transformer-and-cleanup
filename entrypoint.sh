#!/bin/bash

set -e

# Set LANG environment variable
export LANG=C.UTF-8

# Replace "npm-template" with the new repository name in all files
sed -i 's/npm-template/script/g' /github/workspace/package.json

ls
cat package.json

#Delete the .github folder
#if [ -d ".github" ]; then
#  rm -rf .github
#fi

# Commit changes
#git config --local user.email "actions@github.com"
#git config --local user.name "GitHub Actions"
#git add .
#git commit -m "Replace 'my-template' with '${INPUT_TEXT}' and delete .github folder"
#git push origin main

echo "Action completed successfully!"
