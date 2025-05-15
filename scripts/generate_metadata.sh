#!/bin/bash

# Output file
output_file="metadata.csv"

# Write header
echo "Sample_ID,Run_ID,Read1,Read2,Read1_ReadCount,Read2_ReadCount" > $output_file

# Loop through each SRR directory
for dir in SRR239464*/ ; do
    # Remove trailing slash
    run_id=${dir%/}
    
    # Define read file paths
    read1="${run_id}/${run_id}_1.fastq.gz"
    read2="${run_id}/${run_id}_2.fastq.gz"
    
    # Get read counts (number of reads = total lines / 4)
    read1_count=$(zcat "$read1" | wc -l)
    read1_count=$((read1_count/4))
    
    read2_count=$(zcat "$read2" | wc -l)
    read2_count=$((read2_count/4))
    
    # Write to metadata file
    echo "${run_id},${run_id},${read1},${read2},${read1_count},${read2_count}" >> $output_file
done

echo "✅ Metadata generated: $output_file"

