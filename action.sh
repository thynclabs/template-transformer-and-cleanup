#!/bin/bash

set -e

TEXT_TO_REPLACE=$INPUT_TEXT_TO_REPLACE
TEXT=$INPUT_TEXT

# Replace "my-template" with the new repository name in all files
find . -type f -exec sed -i '' "s/$TEXT/$TEXT_TO_REPLACE/g" {} +

 Delete the .github folder
if [ -d ".github" ]; then
  rm -rf .github
fi

# Commit changes
git config --local user.email "actions@github.com"
git config --local user.name "GitHub Actions"
git add .
git commit -m "Replace 'my-template' with '$REPO_NAME' and delete .github folder"
git push origin main

echo "Action completed successfully!"
