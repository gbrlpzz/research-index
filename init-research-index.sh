#!/bin/bash

# init-research-index.sh
# Initializes the research-index repository structure
# Run this INSIDE the research-index directory

echo "Initializing research-index structure..."

# Create folder structure
mkdir -p "00. catalogue" "01. refs" "02. outputs" "03. datasets" "04. notebooks" "05. apps" "06. code" "99. templates"

# Create initial files if they don't exist
[ ! -f "01. refs/references.bib" ] && touch "01. refs/references.bib"
[ ! -f "01. refs/README.md" ] && echo "# Public Bibliography" > "01. refs/README.md" && echo "Store your public references.bib here." >> "01. refs/README.md"

[ ! -f "02. outputs/README.md" ] && echo "# Research Outputs" > "02. outputs/README.md" && echo "Exploratory analyses, essays, and deep dives go here." >> "02. outputs/README.md"

[ ! -f "06. code/README.md" ] && echo "# Code Snippets" > "06. code/README.md" && echo "Small scripts and utilities go here." >> "06. code/README.md"

[ ! -f "03. datasets/README.md" ] && echo "# Datasets" > "03. datasets/README.md" && echo "Small public datasets go here." >> "03. datasets/README.md"

[ ! -f "04. notebooks/README.md" ] && echo "# Notebooks" > "04. notebooks/README.md" && echo "Reproducible notebooks go here." >> "04. notebooks/README.md"

[ ! -f "05. apps/README.md" ] && echo "# Apps" > "05. apps/README.md" && echo "Tiny demos and prototypes go here." >> "05. apps/README.md"

# Create Catalogue files if they don't exist
[ ! -f "00. catalogue/README.md" ] && echo "# Research Catalogue" > "00. catalogue/README.md"
[ ! -f "00. catalogue/papers.md" ] && echo "## Papers" > "00. catalogue/papers.md"
[ ! -f "00. catalogue/apps.md" ] && echo "## Apps" > "00. catalogue/apps.md"
[ ! -f "00. catalogue/datasets.md" ] && echo "## Datasets" > "00. catalogue/datasets.md"
[ ! -f "00. catalogue/notebooks.md" ] && echo "## Notebooks" > "00. catalogue/notebooks.md"

# Create main README if it doesn't exist
if [ ! -f README.md ]; then
cat <<EOF > README.md
# Research Index

This is the public archive and navigation hub for my research ecosystem.

## Structure

- **refs/**: Public bibliography (references.bib)
- **outputs/**: Exploratory analyses, essays, deep dives
- **code/**: Small scripts and utilities
- **datasets/**: Small public datasets
- **notebooks/**: Reproducible notebooks
- **apps/**: Tiny demos
- **catalogue/**: Lists of all artifact repos

## System Guide

See [SYSTEM_GUIDE.md](SYSTEM_GUIDE.md) for the complete manual.
EOF
fi

# Initialize Git
if [ ! -d ".git" ]; then
    git init
    echo "Initialized git repository"
    
    # Create .gitignore
    echo ".DS_Store" > .gitignore
    echo "node_modules/" >> .gitignore
    echo "__pycache__/" >> .gitignore
    echo "*.log" >> .gitignore
    
    git add .
    git commit -m "Initial commit: Research Index structure"
    echo "Created initial commit"
else
    echo "Git already initialized"
fi

echo "Done! research-index structure is ready."
