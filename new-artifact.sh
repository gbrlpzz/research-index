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
TEMPLATES_DIR="$INDEX_DIR/99. templates"
MARKERS_DIR="$TEMPLATES_DIR/markers"

# Detect Catalogue and Refs directories
if [ -d "00. catalogue" ]; then
    CATALOGUE_DIR="00. catalogue"
elif [ -d "catalogue" ]; then
    CATALOGUE_DIR="catalogue"
else
    echo "Error: Catalogue directory not found (looked for 'catalogue' or '00. catalogue')."
    exit 1
fi

if [ -d "01. refs" ]; then
    REFS_DIR="01. refs"
elif [ -d "refs" ]; then
    REFS_DIR="refs"
else
    echo "Error: Refs directory not found (looked for 'refs' or '01. refs')."
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

# Type-specific structure and templates
case $TYPE in
    paper)
        mkdir -p figures refs data/raw data/processed
        touch main.tex
        
        # Copy reproducibility checklist
        if [ -f "$TEMPLATES_DIR/reproducibility.md" ]; then
            cp "$TEMPLATES_DIR/reproducibility.md" REPRODUCIBILITY.md
        else
            echo "# Reproducibility" > REPRODUCIBILITY.md
        fi
        
        if [ -f "$INDEX_DIR/$REFS_DIR/references.bib" ]; then
            cp "$INDEX_DIR/$REFS_DIR/references.bib" refs/
            echo "Copied references.bib from research-index"
        else
            touch refs/references.bib
        fi
        mkdir -p .github/workflows
        echo "name: LaTeX Build" > .github/workflows/latex.yml

        # Copy markers
        [ -f "$MARKERS_DIR/data/raw/README.md" ] && cp "$MARKERS_DIR/data/raw/README.md" data/raw/
        [ -f "$MARKERS_DIR/data/processed/README.md" ] && cp "$MARKERS_DIR/data/processed/README.md" data/processed/
        [ -f "$MARKERS_DIR/figures/README.md" ] && cp "$MARKERS_DIR/figures/README.md" figures/
        ;;
    app)
        mkdir -p src public
        # Copy app manifest
        if [ -f "$TEMPLATES_DIR/app-manifest.json" ]; then
            cp "$TEMPLATES_DIR/app-manifest.json" manifest.json
        fi
        ;;
    dataset)
        mkdir -p raw processed
        # Copy dataset metadata
        if [ -f "$TEMPLATES_DIR/dataset-metadata.md" ]; then
            cp "$TEMPLATES_DIR/dataset-metadata.md" METADATA.md
        else
            echo "# Dataset Metadata" > METADATA.md
        fi
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
CATALOGUE_FILE="$INDEX_DIR/$CATALOGUE_DIR/${TYPE}s.md"

if [ -f "$CATALOGUE_FILE" ]; then
    # Append with a newline to ensure it doesn't mess up previous lines
    # Using printf to ensure newline is handled correctly
    printf "\n- [$REPO_NAME](../../$REPO_NAME) ($YEAR)" >> "$CATALOGUE_FILE"
    echo "Updated catalogue: $CATALOGUE_FILE"
    
    # Commit catalogue update
    cd "$INDEX_DIR" || exit
    git add "$CATALOGUE_DIR/${TYPE}s.md"
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
