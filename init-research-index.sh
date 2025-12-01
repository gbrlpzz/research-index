#!/bin/bash

# init-research-index.sh
# Initializes the research-index repository structure
# Run this INSIDE the research-index directory

echo "Initializing research-index structure..."

# Create folder structure
mkdir -p refs outputs code datasets notebooks apps catalogue

# Create initial files if they don't exist
[ ! -f refs/references.bib ] && touch refs/references.bib
[ ! -f refs/README.md ] && echo "# Public Bibliography" > refs/README.md && echo "Store your public references.bib here." >> refs/README.md

[ ! -f outputs/README.md ] && echo "# Research Outputs" > outputs/README.md && echo "Exploratory analyses, essays, and deep dives go here." >> outputs/README.md

[ ! -f code/README.md ] && echo "# Code Snippets" > code/README.md && echo "Small scripts and utilities go here." >> code/README.md

[ ! -f datasets/README.md ] && echo "# Datasets" > datasets/README.md && echo "Small public datasets go here." >> datasets/README.md

[ ! -f notebooks/README.md ] && echo "# Notebooks" > notebooks/README.md && echo "Reproducible notebooks go here." >> notebooks/README.md

[ ! -f apps/README.md ] && echo "# Apps" > apps/README.md && echo "Tiny demos and prototypes go here." >> apps/README.md

# Create Catalogue files if they don't exist
[ ! -f catalogue/README.md ] && echo "# Research Catalogue" > catalogue/README.md
[ ! -f catalogue/papers.md ] && echo "## Papers" > catalogue/papers.md
[ ! -f catalogue/apps.md ] && echo "## Apps" > catalogue/apps.md
[ ! -f catalogue/datasets.md ] && echo "## Datasets" > catalogue/datasets.md
[ ! -f catalogue/notebooks.md ] && echo "## Notebooks" > catalogue/notebooks.md

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
