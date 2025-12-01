#!/bin/bash

# new-artifact.sh
# Creates a new research artifact repository
# MUST BE RUN FROM INSIDE research-index

if [ "$#" -ne 2 ]; then
    echo "Usage: ./new-artifact.sh <type> <slug>"
    echo "Types: paper, app, dataset, notebook, model"
    exit 1
fi

TYPE=$1
SLUG=$2
YEAR=$(date +%Y)
REPO_NAME="$TYPE-$YEAR-$SLUG"
INDEX_DIR=$(pwd)
BASE_DIR="$INDEX_DIR/.."

# Ensure we are in research-index
if [ ! -d "catalogue" ] || [ ! -d "refs" ]; then
    echo "Error: You must run this script from the root of the research-index repository."
    exit 1
fi

# Validate type
if [[ ! "$TYPE" =~ ^(paper|app|dataset|notebook|model)$ ]]; then
    echo "Error: Invalid type. Must be one of: paper, app, dataset, notebook, model"
    exit 1
fi

echo "Creating new $TYPE artifact: $REPO_NAME"

if [ -d "$BASE_DIR/$REPO_NAME" ]; then
    echo "Error: Directory $BASE_DIR/$REPO_NAME already exists."
    exit 1
fi

# Create artifact in parent directory
mkdir "$BASE_DIR/$REPO_NAME"
cd "$BASE_DIR/$REPO_NAME" || exit

# Create common structure
mkdir -p data code
echo "# $REPO_NAME" > README.md
echo "" >> README.md
echo "Type: $TYPE" >> README.md
echo "Year: $YEAR" >> README.md

# Type-specific structure
case $TYPE in
    paper)
        mkdir -p figures refs
        touch main.tex
        echo "# Reproducibility" > REPRODUCIBILITY.md
        if [ -f "$INDEX_DIR/refs/references.bib" ]; then
            cp "$INDEX_DIR/refs/references.bib" refs/
            echo "Copied references.bib from research-index"
        else
            touch refs/references.bib
        fi
        mkdir -p .github/workflows
        echo "name: LaTeX Build" > .github/workflows/latex.yml
        ;;
    app)
        mkdir -p src public
        ;;
    dataset)
        mkdir -p raw processed
        echo "# Dataset Documentation" > DATA_DICTIONARY.md
        ;;
    notebook)
        mkdir -p notebooks
        ;;
    model)
        mkdir -p weights training_logs
        ;;
esac

# Initialize Git
git init
echo ".DS_Store" > .gitignore
echo "node_modules/" >> .gitignore
echo "__pycache__/" >> .gitignore
echo "*.log" >> .gitignore
echo ".env" >> .gitignore

git add .
git commit -m "Initial commit: $REPO_NAME"

# Update Catalogue in research-index
CATALOGUE_FILE="$INDEX_DIR/catalogue/${TYPE}s.md"

if [ -f "$CATALOGUE_FILE" ]; then
    echo "- [$REPO_NAME](../../$REPO_NAME) ($YEAR)" >> "$CATALOGUE_FILE"
    echo "Updated catalogue: $CATALOGUE_FILE"
    
    # Commit catalogue update
    cd "$INDEX_DIR" || exit
    git add "catalogue/${TYPE}s.md"
    git commit -m "Add $REPO_NAME to catalogue"
    # git push # Uncomment if you want to auto-push index updates
    cd "$BASE_DIR/$REPO_NAME" || exit
else
    echo "Warning: Catalogue file $CATALOGUE_FILE not found."
fi

# GitHub Repo Creation
if command -v gh &> /dev/null; then
    echo "Create GitHub repository for $REPO_NAME? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
        gh repo create "$REPO_NAME" --public --source=. --push
        echo "GitHub repository created and pushed."
    fi
else
    echo "GitHub CLI not found. Create remote manually."
fi

echo "Artifact $REPO_NAME created successfully!"
