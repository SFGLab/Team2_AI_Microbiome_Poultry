## SRA reads downlord from ENA 
mkdir raw_files  # outside the git local repo

## Downlord the metadata for the selected bioproject.
curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=PRJNA707106&result=read_run&fields=run_accession,sample_accession,experiment_accession,library_layout,description,sample_alias,library_strategy,scientific_name,fastq_ftp&format=tsv" -o metadata.tsv

## 
