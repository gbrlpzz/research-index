# Reproducibility Checklist

## Artifact Identification
- **Title**: [Paper Title]
- **Authors**: [Author List]
- **Year**: [Year]
- **DOI**: [Reserved DOI if available]

## Environment
- [ ] `requirements.txt` or `environment.yml` included
- [ ] Python version specified: `x.x.x`
- [ ] OS used for development: [e.g., macOS 14.0]

## Data
- [ ] Raw data available in `data/raw` or link provided
- [ ] Processed data available in `data/processed`
- [ ] Data dictionary / schema provided

## Code
- [ ] Analysis scripts are documented
- [ ] Random seeds are fixed for stochastic processes
- [ ] Main execution script identified (e.g., `run_analysis.sh`)

## Reproduction Steps
1. Install dependencies: `pip install -r requirements.txt`
2. Run data processing: `python code/process_data.py`
3. Run analysis: `python code/analyze.py`
4. Generate figures: `python code/plot_figures.py`

## License
- Code: MIT
- Content: CC BY 4.0
