# DESeq2 Differential Expression Analysis Project

## Overview

This project performs differential expression analysis on RNA-seq data using the DESeq2 package in R. The analysis identifies genes that are differentially expressed between treated and untreated conditions, providing insights into transcriptional changes.

## Project Structure

```
biofinal_project/
├── README.md                       # This documentation file
├── scripts/
│   ├── 01_install_packages.R      # Package installation script
│   └── 02_deseq2_analysis.R      # Main analysis script
├── results/                        # Analysis output files
│   ├── deseq2_results_all.csv     # Complete differential expression results
│   ├── top10_alpha_0.05.csv      # Top 10 genes at p < 0.05
│   ├── top10_alpha_0.001.csv     # Top 10 genes at p < 0.001
│   └── correlation_test.txt       # Correlation analysis results
└── figures/                        # Generated visualization plots
    ├── barplot_library_sizes.png  # Library size distribution
    ├── boxplot_vst.png            # VST-transformed counts quality plot
    ├── heatmap_top10.png          # Heatmap of top 10 genes
    └── scatter_two_genes.png      # Correlation plot of two genes
```

## Prerequisites

-   R (version 4.0.0 or higher)
-   RStudio (recommended)
-   Internet connection for package installation

## Installation and Setup

### 1. Install Required R Packages

Run the package installation script first:

```r
source("scripts/01_install_packages.R")
```

This script installs the following packages:

-   **DESeq2**: Main differential expression analysis package
-   **airway**: Example RNA-seq dataset
-   **SummarizedExperiment**: Data structure for genomic experiments
-   **AnnotationDbi**: Database interface for gene annotations
-   **org.Hs.eg.db**: Human gene annotation database
-   **pheatmap**: Heatmap visualization
-   **tidyverse**: Data manipulation and visualization

### 2. Run the Analysis

```r
source("scripts/02_deseq2_analysis.R")
```

## Analysis Workflow

### Step 1: Data Preparation

-   Load the airway dataset (built-in DESeq2 example data)
-   Set up experimental design with proper reference levels
-   Create DESeq2 dataset object

### Step 2: Differential Expression Analysis

-   Perform DESeq2 analysis with default parameters
-   Extract results at significance threshold α = 0.05
-   Sort results by adjusted p-value

### Step 3: Gene Annotation

-   Map Ensembl IDs to human-readable gene symbols
-   Create comprehensive results table with annotations

### Step 4: Quality Control

-   Generate VST-transformed data for visualization
-   Create quality control plots (boxplots, library sizes)

### Step 5: Visualization

-   Heatmap of top differentially expressed genes
-   Correlation analysis between top genes
-   Export all visualizations as high-resolution PNG files

### Step 6: Results Export

-   Save complete results to CSV format
-   Export filtered results at different significance levels
-   Save correlation test results

## Output Files

### Results Files

1. **`deseq2_results_all.csv`**: Complete differential expression results including:

    - Ensembl ID
    - Gene symbol
    - Base mean expression
    - Log2 fold change
    - Standard error
    - Wald statistic
    - P-value
    - Adjusted p-value

2. **`top10_alpha_0.05.csv`**: Top 10 differentially expressed genes at p < 0.05

3. **`top10_alpha_0.001.csv`**: Top 10 differentially expressed genes at p < 0.001

4. **`correlation_test.txt`**: Pearson correlation test results between top two genes

### Visualization Files

1. **`barplot_library_sizes.png`**: Bar plot showing total read counts per sample
2. **`boxplot_vst.png`**: Box plot of VST-transformed counts for quality assessment
3. **`heatmap_top10.png`**: Heatmap visualization of top 10 differentially expressed genes
4. **`scatter_two_genes.png`**: Scatter plot showing correlation between two top genes

## Data Description

The analysis uses the **airway** dataset, which contains RNA-seq data from airway smooth muscle cells treated with dexamethasone (a glucocorticoid steroid). The dataset includes:

-   **4 untreated samples** (control)
-   **4 treated samples** (dexamethasone treatment)
-   **58,037 genes** (Ensembl IDs)
-   **Quality metrics** and sample metadata

## Customization Options

### Change Significance Threshold

```r
# Modify the alpha parameter in the results() function
res <- results(dds, alpha = 0.01)  # More stringent threshold
```

### Modify Output File Names

```r
# Change output file paths as needed
write.csv(res_tbl, "results/my_custom_results.csv", row.names = FALSE)
```

### Adjust Plot Parameters

```r
# Modify plot dimensions and resolution
png("figures/my_plot.png", width = 2000, height = 1500, res = 300)
```

## Troubleshooting

### Common Issues

1. **Package Installation Errors**

    - Ensure you have the latest R version
    - Try installing packages individually
    - Check Bioconductor installation

2. **Memory Issues**

    - Close other R sessions
    - Increase R memory limit if possible
    - Process data in smaller chunks

3. **Annotation Database Issues**
    - Ensure org.Hs.eg.db is properly installed
    - Check internet connection for database updates

### Error Messages

-   **"object 'airway' not found"**: Run `data("airway")` first
-   **"package not found"**: Install missing packages using the installation script
-   **"cannot open file"**: Check file permissions and directory existence
