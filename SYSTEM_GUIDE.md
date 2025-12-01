# **Research Repository System — Complete Instruction Guide**

## **1. Purpose**

This system organizes all your public research outputs in a way that is:

* **minimal**
* **modular**
* **interoperable**
* **open-science compliant**
* **future-proof**
* **easy to maintain**
* **flexible**

Private notes live outside GitHub (Obsidian), so only **public-ready research artifacts** appear in this system.

---

# **2. Architecture Overview**

Your ecosystem has **two layers**:

```
1. research-index/           ← public archive + catalogue + shared outputs
2. artifact repos (public):
      paper-YYYY-xyz/
      app-YYYY-xyz/
      dataset-YYYY-xyz/
      notebook-YYYY-xyz/
```

Everything public that isn’t a formal paper lives in **research-index**.
Everything that *is* a formal, DOI-ready paper lives in its own repo.

Stand-alone apps, datasets, and notebooks can also have dedicated repos **only when needed**.

---

# **3. What Goes Where**

## **3.1 research-index (public)**

This is your **public research archive and navigation hub**.
It stores all *non-paper* research artifacts that are ready to share.

### Use it for:

* exploratory analyses
* deep dives
* essays and technical notes
* small datasets
* small apps or demos
* reproducible notebooks
* code snippets
* cleaned figures
* your **public bibliography**
* documentation
* catalogues linking all other repos

### **3.1 Directory Structure**

```
research-index/
  00. catalogue/     # Index of all artifact repos
  01. refs/          # Public bibliography
  02. outputs/       # Analyses, deep dives, essays
  03. datasets/      # Small public datasets
  04. notebooks/     # Reproducible notebooks
  05. apps/          # Small app demos (not full applications)
  06. code/          # Small code utilities
  99. templates/     # Standard metadata templates & markers
  README.md
  SYSTEM_GUIDE.md
```

### This repo is:

* the public “hub” of your academic identity
* the index for all individual artifact repos
* safe to share widely
* easy to navigate

---

## **3.2 paper-YYYY-slug (public)**

Use ONLY for **formal scientific papers**, preprints, or manuscripts.

A “paper repo” must be:

* **self-contained**
* **reproducible**
* **Zenodo-compatible**
* capable of standing alone as an artifact

### Contains:

```
main.tex
figures/
data/                  ← small processed data only
code/                  ← minimal analysis scripts
refs/references.bib    ← copied from research-index/refs
REPRODUCIBILITY.md
.github/workflows/latex.yml
README.md
```

### Why separate?

* Clean DOI snapshots
* ETH reproducibility checks
* Avoid mixing with unrelated analyses
* Easy to cite and archive
* Clear version history

---

## **3.3 Optional standalone artifact repos**

Use these ONLY when an artifact is large enough to deserve its own repo, or when it needs independent versioning.

### **app-YYYY-slug/**

For:

* full apps
* interactive resources
* visualization tools
* anything with its own codebase

### **dataset-YYYY-slug/**

For:

* large datasets
* multi-paper datasets
* datasets needing their own DOI

### **notebook-YYYY-slug/**

For:

* standalone computational essays
* reproducible showcases
* clean single-purpose notebooks

### **model-YYYY-slug/**

For:

* ML models
* ABMs
* simulations

---

# **4. When to Create a New Repo**

Use this decision rule:

### **YES → make new repo**

If an artifact is:

* formal
* standalone
* citable
* versioned
* needs its own DOI
* used by others
* part of a software/codebase
* too big or too structured for research-index

### **NO → keep inside research-index**

If an artifact is:

* exploratory
* semi-formed
* not citable
* a deep dive
* a small script
* a dataset under ~10MB
* a notebook tied to experimentation
* rough code demos

This keeps the system **small**, **clean**, and **scalable**.

---

# **5. Using the Automation Scripts**

You have two automation scripts located in the root of this repository (`research-index`).

## **5.1 init-research-index.sh**

Run this if you need to re-initialize or repair the folder structure.

```
./init-research-index.sh
```

It creates/verifies:

* folder structure
* README
* catalogue files

---

## **5.2 new-artifact.sh**

Use this for all new public artifacts. **Must be run from the `research-index` directory.**

### Script usage:

```
./new-artifact.sh <type> <slug>
```

### Examples:

#### Create a paper repo:

```
./new-artifact.sh paper governanceos-wicked
```

#### Create an app repo:

```
./new-artifact.sh app oci-visualizer
```

#### Create a dataset repo:

```
./new-artifact.sh dataset rural-indicators
```

#### Create a notebook repo:

```
./new-artifact.sh notebook heatmap-analysis
```

### What the script does:

* creates folder in the **parent directory** (sibling to `research-index`)
* adds correct template
* initializes git
* creates GitHub repo
* pushes to GitHub
* updates the corresponding catalogue file inside `research-index`
* commits & pushes the updated index

This guarantees:

* everything is documented
* everything is findable
* index stays current
* repos follow the naming standard

---

# **6. Updating the Public Bibliography**

You maintain a public bibliography in:

```
research-index/refs/references.bib
```

When updated:

```
cd research-index
git add refs/references.bib
git commit -m "update references"
git push
```

Paper repos **copy** this file—no submodules (Zenodo-safe).

---

# **7. Long-Term Workflow Summary**

### **Daily:**

Private notes stay in Obsidian.
Explorations go in `research-index/outputs`.

### **When something becomes solid:**

Move it into a dedicated folder under `research-index`.

### **When something becomes formal (“publishable”):**

Use `new-artifact.sh` to give it its own repo.

### **When writing a paper:**

Use `new-artifact.sh paper slug`.

### **When releasing a dataset or app:**

Use `new-artifact.sh dataset slug` or `app slug`.

### **The system grows with your actual outputs, not with bureaucracy.**

---

# **8. Why This Is the Optimal Setup**

### **Minimal**

Only create new repos when needed.

### **Modular**

Every artifact is isolated and self-contained.

### **Interoperable**

Each standalone repo is:

* Zenodo-ready
* DataCite-typed
* ETH-reproducible

### **Public-facing identity**

`research-index` functions as a:

* personal knowledge library
* research archive
* project list
* citation hub
* easy-to-browse portfolio

### **Future-proof**

You can add new artifact types or merging strategies without breaking anything.
