#!/bin/bash

# Base directory
BASE_DIR="/home/biftrain10/PRJNA947933"
cd $BASE_DIR

# Create folders
mkdir -p raw_data fastqc_results processed_data/cleaned_fastq processed_data/kraken2_results processed_data/bracken_results multiqc_report scripts databases

# Move SRR fastq files (assuming fastq.gz) to raw_data
mv SRR* raw_data/

# Move your generate_metadata.sh and other scripts into scripts
mv generate_metadata.sh scripts/

# Move fastqc files
mv FastQC fastqc_results/ 2>/dev/null
mv fastqc_results fastqc_results/ 2>/dev/null

echo "✅ Directory structure created and files organized."

