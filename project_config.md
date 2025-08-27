# Project Configuration

## Quick Start

1. **Install R** (version 4.0.0 or higher)
2. **Open RStudio** and set this directory as your working directory
3. **Install packages**: `source("scripts/01_install_packages.R")`
4. **Run analysis**: `source("scripts/02_deseq2_analysis.R")`

## Dependencies

### Core R Packages

-   **R**: 4.0.0+
-   **RStudio**: Recommended (not required)

### Bioconductor Packages

-   **DESeq2**: 1.30.0+ (differential expression analysis)
-   **airway**: Example dataset
-   **SummarizedExperiment**: Data structure
-   **AnnotationDbi**: Database interface
-   **org.Hs.eg.db**: Human gene annotations
-   **pheatmap**: Heatmap visualization

### CRAN Packages

-   **tidyverse**: Data manipulation and visualization
-   **IRkernel**: Jupyter kernel (optional)

## File Paths

### Input

-   **Data**: Built-in `airway` dataset (no external files needed)

### Output

-   **Results**: `results/` directory
-   **Figures**: `figures/` directory
-   **Logs**: Console output

## Configuration Options

### Analysis Parameters

```r
# Significance threshold
alpha = 0.05  # Default: 0.05

# Number of top genes to visualize
n_top_genes = 10  # Default: 10

# Plot resolution
plot_res = 150  # Default: 150 DPI
```

### File Naming

```r
# Results files
results_file = "results/deseq2_results_all.csv"
top_genes_file = "results/top10_alpha_0.05.csv"

# Figure files
heatmap_file = "figures/heatmap_top10.png"
boxplot_file = "figures/boxplot_vst.png"
```

## Memory Requirements

-   **Minimum**: 2GB RAM
-   **Recommended**: 4GB+ RAM
-   **Storage**: 500MB for packages, 100MB for results

## Performance Notes

-   **Installation**: 5-15 minutes (depending on internet speed)
-   **Analysis**: 2-5 minutes
-   **Output generation**: 1-2 minutes

## Troubleshooting

### Common Issues

-   **Bioconductor errors**: Update R to latest version
-   **Memory issues**: Close other applications
-   **Package conflicts**: Restart R session

### Error Codes

-   **E001**: Package not found
-   **E002**: Insufficient memory
-   **E003**: File permission denied
