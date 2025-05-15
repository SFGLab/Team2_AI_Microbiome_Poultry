
# Team2_AI_Microbiome_Poultry

A collaborative BioAI Hackathon project applying machine learning to poultry microbiome data for predictive health and production trait modeling.

---

## 📌 Team
- Mxolisi Nene (Team Lead)  
- Karthikeyan Govindan  
- Rajarshi Mondal  

---

## 🎯 Goal
Use publicly available poultry microbiome datasets (16S rRNA / Metagenomics) to identify microbial biomarkers associated with growth, gut health, and disease resistance using AI techniques.

---

## 🛠️ Methodology
- Data preprocessing & normalization  
- Microbiome taxonomic profiling using:
  - **Shotgun metagenomics:** Kraken2  
  - **16S rRNA amplicon sequencing:** DADA2  
- ML techniques:
  - Clustering  
  - Classification  
  - Feature selection  
- Results interpretation & visualization

---

## 📦 Deliverables
- AI-informed microbiome health prediction model  
- Presentation & report for BioAI Hackathon 2025  

---

## 📄 License
MIT  

---

## 📊 Workflow Diagram

```mermaid
flowchart TD
  A[Download SRA] --> B[QC & Trim]
  B --> C{Shotgun?}
  C -->|Yes| D[Kraken2 Profiling]
  C -->|No| E[DADA2 16S Processing]
  D --> F[Generate Taxa Table]
  E --> G[Generate Feature Table]
  F --> H[Model Training]
  G --> H
  H --> I[Report]
```

---

# 📥 Data Retrieval and Preprocessing

## 📜 Script: `data_retrieval.sh`

This script automates the process of:

1. Downloading sequencing data from ENA using a BioProject ID  
2. Performing adapter trimming using `fastp`  
3. Generating a MultiQC report for quality control  

---

## ▶️ Usage

To run the script, use the following command:

```bash
./data_retrieval.sh [BioProject_ID]
```

### 🔍 Example

```bash
./data_retrieval.sh PRJNA707106
```

⚙️ Data Processing Pipeline Using DADA2 in R
📜 Script: dada2_script.R

This script automates the essential preprocessing steps for amplicon sequencing data, including:

    ✂️ Quality filtering and primer trimming to clean raw reads

    🔗 Merging paired-end reads for accurate sequence reconstruction

    🚫 Removing chimeras to ensure data integrity

    🎯 Generating the final Amplicon Sequence Variant (ASV) table ready for taxonomic classification

🧬 Taxonomic Annotation

    Taxonomy is assigned using the SILVA reference database:
    silva_nr99_v138.1_wSpecies_train_set.fa.gz

    Outputs include taxonomic tables at the Genus and Species levels

    Results are saved as CSV files, paired with metadata for easy integration

🚀 Ready for Downstream Analysis

The processed data is perfectly formatted to jump straight into:

    Machine learning workflows

    Visualization and reporting
