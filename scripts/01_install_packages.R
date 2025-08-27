# =============================================================================
# Package Installation Script for DESeq2 Analysis
# =============================================================================
#
# This script installs all required packages for the DESeq2 differential
# expression analysis project. It handles both Bioconductor and CRAN packages.
#
# Run this script ONCE before running the main analysis script.
# 
# Prerequisites:
# - R (version 4.0.0 or higher)
# - Internet connection
# - Sufficient disk space (~500MB for all packages)
#
# Author: Navid Ghasemi
# Student ID: 4012013038
# Date: 2025-08-27
# =============================================================================

# Install BiocManager if not already present
# BiocManager is required to install Bioconductor packages
if (!requireNamespace("BiocManager", quietly = TRUE)) {
  message("Installing BiocManager...")
  install.packages("BiocManager")
}

# Define Bioconductor packages required for the analysis
bioc_pkgs <- c(
  "DESeq2",                    # Main differential expression analysis package
  "airway",                    # Example RNA-seq dataset for testing
  "AnnotationDbi",             # Database interface for gene annotations
  "org.Hs.eg.db",              # Human gene annotation database (Ensembl to Symbol mapping)
  "SummarizedExperiment",      # Data structure for genomic experiments
  "pheatmap"                   # High-quality heatmap visualization
)

# Install Bioconductor packages
message("Installing Bioconductor packages...")
BiocManager::install(bioc_pkgs, ask = FALSE, update = TRUE)

# Define CRAN packages required for the analysis
cran_pkgs <- c(
  "tidyverse",                 # Data manipulation and visualization (includes ggplot2, dplyr, etc.)
  "IRkernel"                   # Jupyter kernel for R (optional, for notebook users)
)

# Install CRAN packages only if not already installed
to_install <- setdiff(cran_pkgs, rownames(installed.packages()))
if (length(to_install)) {
  message("Installing CRAN packages: ", paste(to_install, collapse = ", "))
  install.packages(to_install)
} else {
  message("All CRAN packages already installed.")
}

# Verify installation by loading key packages
message("Verifying package installation...")
tryCatch({
  library(DESeq2)
  library(airway)
  library(tidyverse)
  message("✅ Core packages loaded successfully!")
}, error = function(e) {
  message("❌ Error loading packages: ", e$message)
  message("Please check the installation and try again.")
})

message("✅ Package installation complete!")
message("You can now run the main analysis script: source('scripts/02_deseq2_analysis.R')")
