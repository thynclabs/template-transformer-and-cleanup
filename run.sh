#!/bin/bash

# Function to replace keyword in a file
replace_keyword() {
    local file=$1
    local search=$2
    local replace=$3

    # Use awk to replace the keyword and create a temporary file
    awk -v search="$search" -v replace="$replace" '{gsub(search, replace); print}' "$file" > "$file.tmp"

    # Move the temporary file to the original file
    mv "$file.tmp" "$file"
}

# Trim function to remove leading and trailing whitespace
trim() {
    local var="$*"
    # Remove leading whitespace characters
    var="${var#"${var%%[![:space:]]*}"}"
    # Remove trailing whitespace characters
    var="${var%"${var##*[![:space:]]}"}"
    echo -n "$var"
}

# Function to recursively process directories
process_directory() {
    local dir=$1
    local search=$2
    local replace=$3

    # Iterate over all files and directories within the given directory
    for item in "$dir"/*; {
        if [ -d "$item" ]; then
            # If the item is a directory, recursively process it
            process_directory "$item" "$search" "$replace"
        elif [ -f "$item" ]; then
            # If the item is a file, replace the keyword in it
            replace_keyword "$item" "$search" "$replace"
        fi
    }
}

# Get script arguments
#search_keyword=$1
#replace_keyword=$2

# Process the given directory
process_directory "./" "${INPUT_SEARCH_KEYWORD}" "${INPUT_REPLACE_KEYWORD}"

git config --global --add safe.directory /github/workspace
git config --global user.email "actions@github.com"
git config --global user.name "GitHub Actions"

git status
ls

git add .
git commit -am "Replace keyword ${INPUT_SEARCH_KEYWORD} with ${INPUT_REPLACE_KEYWORD}"

# Get the GITHUB_URL environment variable and trim it
GITHUB_URL=$(trim "${INPUT_GITHUB_URL}")

# Extract the protocol (e.g., 'https:' or 'http:')
GITHUB_URL_PROTOCOL=$(echo "$GITHUB_URL" | cut -d'/' -f1)

# Extract the rest of the URL (e.g., 'github.com/user/repo')
GITHUB_URL_HOST=$(echo "$GITHUB_URL" | cut -d'/' -f3-)

# Construct the remote repository URL
remote_repo="${GITHUB_URL_PROTOCOL}//oauth2:${INPUT_WORKFLOW_TOKEN}@${GITHUB_URL_HOST}/${INPUT_REPOSITORY}.git"

# Push to the remote repository
git push "${remote_repo}" HEAD:"${INPUT_BRANCH}"
