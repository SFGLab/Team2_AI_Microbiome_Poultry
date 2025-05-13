#!/usr/bin/env Rscript

library(optparse)
library(randomForest)

option_list = list(
  make_option(c("-a", "--abundance"), type="character", help="Path to abundance table (CSV)"),
  make_option(c("-m", "--metadata"), type="character", help="Path to metadata file (CSV)"),
  make_option(c("-o", "--output"), type="character", help="Output model file (.rds)")
)

opt_parser = OptionParser(option_list=option_list)
opt = parse_args(opt_parser)

# Load data
abundance <- read.csv(opt$abundance, row.names = 1)
metadata <- read.csv(opt$metadata)

# Merge data (assuming sample IDs are rownames in abundance and 'SampleID' column in metadata)
merged_data <- merge(abundance, metadata, by.x="row.names", by.y="SampleID")

# Example: Fit random forest to predict a target variable (e.g. 'Group')
rf_model <- randomForest(Group ~ ., data=merged_data[,-1], importance=TRUE)

# Save model
saveRDS(rf_model, file=opt$output)
cat("Model saved to", opt$output, "\n")
