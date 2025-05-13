# Team2_AI_Microbiome_Poultry

A collaborative BioAI Hackathon project applying machine learning to poultry microbiome data for predictive health and production trait modeling.

<<<<<<< HEAD
## Team
=======
---

## 📌 Team
>>>>>>> 373c3461f7923987e89a4f161f3d09e5685b0813
- Mxolisi Nene (Team Lead)
- Karthikeyan Govindan
- Rajarshi Mondal

<<<<<<< HEAD
## Goal
Use publicly available poultry microbiome datasets (16S rRNA / Metagenomics) to identify microbial biomarkers associated with growth, gut health, and disease resistance using AI techniques.

## Methodology
- Data preprocessing & normalization
- ML techniques: clustering, classification, feature selection
- Results interpretation & visualization

## Deliverables
- AI-informed microbiome health prediction model
- Presentation & report for BioAI Hackathon 2025

## License
MIT
=======
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
  C -->|true| D[Kraken2 Profiling]
  C -->|false| E[DADA2 16S Processing]
  D --> F[Generate Taxa Table]
  E --> G[Generate Feature Table]
  F --> H[Model Training]
  G --> H
  H --> I[Report]

>>>>>>> 373c3461f7923987e89a4f161f3d09e5685b0813
