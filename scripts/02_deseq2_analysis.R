# =============================================================================
# DESeq2 Differential Expression Analysis Script
# =============================================================================
# 
# This script performs differential expression analysis using DESeq2 on RNA-seq data
# from the airway dataset. It identifies differentially expressed genes between
# treated and untreated conditions and generates various visualizations.
#
# Analysis Steps:
# 1. Data preparation and quality control
# 2. Differential expression analysis with DESeq2
# 3. Gene annotation and result filtering
# 4. Visualization generation
# 5. Result export
#
# Input: airway dataset (built-in DESeq2 example data)
# Output: CSV results files and PNG visualization plots
#
# Author: Navid Ghasemi 
# Student ID: 4012013038
# Date: 2025-08-27
# =============================================================================

# Load required packages with startup messages suppressed
suppressPackageStartupMessages({
  library(DESeq2)           # Main differential expression analysis package
  library(airway)           # Example RNA-seq dataset
  library(SummarizedExperiment)  # Data structure for genomic experiments
  library(AnnotationDbi)    # Database interface for gene annotations
  library(org.Hs.eg.db)     # Human gene annotation database
  library(pheatmap)         # Heatmap visualization
  library(tidyverse)        # Data manipulation and visualization
})

# Create output directories for results and figures
dir.create("figures", showWarnings = FALSE, recursive = TRUE)
dir.create("results", showWarnings = FALSE, recursive = TRUE)

# =============================================================================
# DATA PREPARATION
# =============================================================================

# Load the airway dataset (example RNA-seq data)
data("airway")
se <- airway

# Relevel the treatment factor to set "untrt" (untreated) as the reference level
# This ensures proper comparison in the statistical model
se$dex <- relevel(factor(se$dex), ref = "untrt")

# =============================================================================
# DIFFERENTIAL EXPRESSION ANALYSIS
# =============================================================================

# Create DESeq2 dataset object with the design formula
# Design: ~ dex (treatment condition as the main factor)
dds <- DESeqDataSet(se, design = ~ dex)

# Run DESeq2 analysis (performs normalization, dispersion estimation, and testing)
dds <- DESeq(dds)

# Extract results with significance threshold alpha = 0.05
res <- results(dds, alpha = 0.05)

# Sort results by adjusted p-value (most significant first)
res <- res[order(res$padj), ]

# Remove genes with missing adjusted p-values
res <- res[!is.na(res$padj), ]

# =============================================================================
# GENE ANNOTATION
# =============================================================================

# Extract Ensembl IDs from results
ens_ids <- rownames(res)

# Map Ensembl IDs to gene symbols using the human annotation database
# This provides human-readable gene names instead of just Ensembl IDs
symbols <- AnnotationDbi::mapIds(
  org.Hs.eg.db,           # Human gene annotation database
  keys = ens_ids,          # Ensembl IDs to map
  keytype = "ENSEMBL",     # Input ID type
  column = "SYMBOL",       # Output column type
  multiVals = "first"      # Handle multiple matches by taking first
)

# Create a comprehensive results table with both Ensembl IDs and gene symbols
res_tbl <- as.data.frame(res) %>%
  rownames_to_column("ensembl_id") %>%           # Convert rownames to column
  mutate(symbol = symbols[ensembl_id]) %>%       # Add gene symbols
  relocate(symbol, .after = ensembl_id)          # Reorder columns for readability

# =============================================================================
# RESULT EXPORT
# =============================================================================

# Export complete results table
write.csv(res_tbl, "results/deseq2_results_all.csv", row.names = FALSE)

# Filter and export top differentially expressed genes at different significance levels
top_0_05 <- res_tbl %>% filter(padj < 0.05) %>% slice_head(n = 10)      # Top 10 at p < 0.05
top_0_001 <- res_tbl %>% filter(padj < 0.001) %>% slice_head(n = 10)    # Top 10 at p < 0.001

write.csv(top_0_05, "results/top10_alpha_0.05.csv", row.names = FALSE)
write.csv(top_0_001, "results/top10_alpha_0.001.csv", row.names = FALSE)

# =============================================================================
# QUALITY CONTROL VISUALIZATIONS
# =============================================================================

# Perform variance stabilizing transformation (VST) for visualization
# VST stabilizes variance across the mean, making data suitable for plotting
vsd <- vst(dds, blind = TRUE)

# Generate boxplot of VST-transformed counts to assess data quality
png("figures/boxplot_vst.png", width = 1400, height = 900, res = 150)
boxplot(assay(vsd), outline = FALSE, las = 2, main = "VST-transformed counts")
dev.off()

# Calculate and visualize library sizes (total counts per sample)
lib_sizes <- colSums(counts(dds))
png("figures/barplot_library_sizes.png", width = 1200, height = 800, res = 150)
barplot(lib_sizes, las = 2, main = "Library sizes (total raw counts)")
dev.off()

# =============================================================================
# EXPLORATORY VISUALIZATIONS
# =============================================================================

# Create heatmap of top 10 differentially expressed genes
top_genes <- head(res_tbl$ensembl_id, 10)        # Select top 10 genes
mat <- assay(vsd)[top_genes, ]                    # Extract VST data for top genes
mat <- mat - rowMeans(mat)                        # Center data by row means (Z-score like)

# Prepare annotation for the heatmap columns
ann_col <- data.frame(dex = colData(se)$dex)     # Treatment condition annotation
rownames(ann_col) <- colnames(mat)                # Match annotation to sample names

# Generate heatmap
png("figures/heatmap_top10.png", width = 1200, height = 900, res = 150)
pheatmap(mat, annotation_col = ann_col, show_rownames = TRUE)
dev.off()

# =============================================================================
# GENE CORRELATION ANALYSIS
# =============================================================================

# Select two top genes for correlation analysis
geneA <- top_genes[1]                            # First top gene
geneB <- top_genes[2]                            # Second top gene

# Get normalized counts for these genes
norm_counts <- counts(dds, normalized = TRUE)     # DESeq2 normalized counts
x <- log2(norm_counts[geneA, ] + 1)              # Log2 transform gene A
y <- log2(norm_counts[geneB, ] + 1)              # Log2 transform gene B

# Create scatter plot of the two genes across samples
png("figures/scatter_two_genes.png", width = 1000, height = 800, res = 150)
plot(x, y, xlab = geneA, ylab = geneB, main = "Scatter of two genes")
text(x, y, labels = colnames(norm_counts), pos = 3, cex = 0.8)  # Add sample labels
dev.off()

# Perform correlation test between the two genes
ct <- cor.test(x, y, method = "pearson")         # Pearson correlation test
capture.output(ct, file = "results/correlation_test.txt")  # Save correlation results

# =============================================================================
# COMPLETION MESSAGE
# =============================================================================

message("✅ Analysis complete! Check results/ and figures/ folders.")
