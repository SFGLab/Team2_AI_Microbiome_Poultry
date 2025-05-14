#!/bin/bash

## downlord SRA reads from ENA  for specific Bioproject ID
mkdir raw_files  # outside the git local repo

cd raw files 
./python3/enaGroupGet -g read -f fastq $1 -d ../raw_files/


## Downlord the metadata for the selected bioproject.
curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJNA707106&result=read_run&fields=run_accession,sample_accession,experiment_accession,library_layout,description,sample_alias,library_strategy,scientific_name,fastq_ftp&format=tsv" -o /home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects/metadata.tsv

## Preprocessing the reads for adaptor removal and low quality trimming using fastp

mkdir fastp
# Create a directory to store output for each prefix
for file_R1 in /home/karthi/bioai/raw_files/$1/*/*_1.fastq.gz; do
    if [ -e "$file_R1" ]; then
        prefix=$(basename "$file_R1" | cut -d '_' -f 1)
        file_R2="${file_R1/_1/_2}"

# Run fastp command
fastp -i "$file_R1" \
      -o "fastp/${prefix}_R1_adrm.fastq.gz" \
      -I "$file_R2" \
      -O "fastp/${prefix}_R2_adrm.fastq.gz" \
        --detect_adapter_for_pe \
	-j "fastp/${prefix}.json" \
	-h "fastp/${prefix}.html"
	fi
done

## run multiqc for compling the results of fastp

cd ./fastp
multiqc . -o /home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects/

## end ##


