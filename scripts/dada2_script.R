# 15 MAY 2025
# ASV analysis in DADA2
# raw fastq files were downloded from ENA BioProject PRJNA707106
# raw fastq files were adaptor removed using fastp and the adaptor removed 
# files were used for dada2.

# code starts from here 
# R - version - 4.2

setwd("/home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects")
# libraries to activate 
library(dada2); packageVersion("dada2")
library(phyloseq) # to create a phyloseq object
library(data.table)
library(dplyr) # for data manipulation.

# gathering the sample fastq into one object
path<- "/media/seqlab/One Touch/seqlab/bioai/fastp/" 
# ensure only fastq files were present no other logs and json files.

list.files(path) #  check for the listed files.

# Select the forward and reverse fastq files separtely based on the pattern
# Forward and reverse fastq filenames have format: SAMPLENAME_R1_adrm.fastq and 
# SAMPLENAME_R2_adrm.fastq
fnFs <- sort(list.files(path, pattern="_R1_adrm.fastq", full.names = TRUE))
list(fnFs) # to check the count of forward reads

fnRs <- sort(list.files(path, pattern="_R2_adrm.fastq", full.names = TRUE))
list(fnRs) # to check the count of forward reads

# Extract sample names, assuming filenames have format: SAMPLENAME_XXX.fastq
sample.names <- sapply(strsplit(basename(fnFs), "_"), `[`, 1)  
list(sample.names)

# visualizing the quality profiles of the forward reads
plotQualityProfile(fnFs[1:40]) # change the numer to get the specific file
# visualizing the quality profiles of the reverse reads
plotQualityProfile(fnRs[1:40])
# the r graphics will show only the 2 files or multiple files seprately and 
# not as single quality plot. The fastp QC  was done seperately and the report 
# was saved to multiqc report for both read-1 and read-2 
#  [objectes/mutiqc_report_1.html].

# based on the fastp and dada2 plotqualityprofile trimming parameters was choosen
# forward trim at 240
# reverse trim at 240 

## Filter  and trim ##
# creating new filtered files in fil/ subdirectory
filtFs <- file.path(path, "fil", paste0(sample.names, "_F_filt.fastq.gz"))
filtRs <- file.path(path, "fil", paste0(sample.names, "_R_filt.fastq.gz"))

# trimming the ends based on the QC (truncLen=c(240,240),and removing the 
# primers (trimLeft = c(19,20))
out <- filterAndTrim(fnFs, filtFs, fnRs,filtRs, truncLen=c(240,240),
                     trimLeft = c(19,20), rm.phix=TRUE, compress=TRUE, 
                     multithread=TRUE)
head(out)

# Learn the Error Rates( 10 min )
errF <- learnErrors(filtFs, multithread=TRUE) 

errR <- learnErrors(filtRs, multithread=TRUE)

#plotErrors(errF, nominalQ=TRUE)
#plotErrors(errR, nominalQ=TRUE)
# in both f and R the error rate decreases , while increase in quality score

# Dereplication for unique reads
derepFs <- derepFastq(filtFs, verbose=TRUE)

derepRs <- derepFastq(filtRs, verbose=TRUE)

# Name the derep-class objects by the sample names
names(derepFs) <- sample.names
dadaFs <- dada(derepFs, err=errF, multithread=TRUE)

names(derepRs) <- sample.names
dadaRs <- dada(derepRs, err=errR, multithread=TRUE)

# merging paired reads
mergers <- mergePairs(dadaFs, filtFs, dadaRs, filtRs, verbose=TRUE)

# Inspect the merger data.frame from the first sample
head(mergers[[1]])
# Construct sequence table [ ASV -table]
seqtab <- makeSequenceTable(mergers)

# dimensions 
dim(seqtab)
# 40 11285

# Inspect distribution of sequence lengths
table(nchar(getSequences(seqtab)))
# the table shows the distribution of  amplicon length.

# Retain only the amplicons with legth 400 +
seqtab_filt <- seqtab[,nchar(colnames(seqtab)) %in% 400:500]

table(nchar(getSequences(seqtab_filt))) 

saveRDS(seqtab_filt,file ="/media/seqlab/OneTouch/seqlab/bioai/seqtab_filt.rds")
dim(seqtab_filt)
# 15 11115

# Remove chimeras from the merged amplicons
seqtab.nochim_p2 <- removeBimeraDenovo(seqtab_filt, method="consensus",
                                       multithread=TRUE, verbose=TRUE)
dim(seqtab.nochim_p2)
# 15 3380
# proportion (or fraction) of total reads retained after chimera removal.
sum(seqtab.nochim_p2)/sum(seqtab_filt)
# [1] 0.9193233 (92%)

# get track of complete details of each read 
getN <- function(x) sum(getUniques(x))
track <- cbind(out, sapply(dadaFs, getN), sapply(dadaRs, getN), 
               sapply(mergers, getN), rowSums(seqtab.nochim_p2))
colnames(track) <- c("input","filtered","denoisedF",
                     "denoisedR","merged","nonchim")
rownames(track) <- sample.names
head(track)
write.csv(track, file = "/media/seqlab/One Touch/seqlab/bioai/track.csv")

# Assign taxonomy 
taxa <- assignTaxonomy(seqtab.nochim_p2,
        "/home/seqlab/Data_16s/silva_nr99_v138.1_wSpecies_train_set.fa.gz", 
        multithread=TRUE) #( 15 min)
# write.csv(taxa, "/media/seqlab/One Touch/seqlab/bioai/taxa.csv")

# creating ps object 
# extract only the valid samples from seqtab.nochim 
samples.out<- rownames(seqtab.nochim_p2)
# metadata for the samples ( only sample ids )"
meta<- read.csv("/home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects/metadata.tsv", sep= "\t")
## retain only the group information and sample source information
meta <- meta[, c(1,6)]
colnames(meta)[1] <- "Sample_ID"
rownames(meta) <- meta$Sample_ID
## make a new colum for group varibale
meta$group <- ifelse(grepl("^H", meta$sample_alias), "HBW", "LBW")
# HBW - High Body weight 
# LOW - Low Body weight

# creating the phyloseq object
ps <- phyloseq(otu_table(seqtab.nochim_p2, taxa_are_rows=FALSE), 
               sample_data(meta), 
               tax_table(taxa))

ps # to check for the objects in ps
# phyloseq-class experiment-level object
# otu_table()   OTU Table:         [ 3380 taxa and 40 samples ]
# sample_data() Sample Data:       [ 40 samples by 3 sample variables ]
# tax_table()   Taxonomy Table:    [ 3380 taxa by 7 taxonomic ranks ]

# save this ps for further analysis 
saveRDS(ps, file = "/home/karthi/bioai/ps.rds")

## Taxa at genus level
# Aggregate data on the genus level
genus_level <- tax_glom(ps, "Genus")

# Transform to relative abundance
genus_relabund <- transform_sample_counts(genus_level, function(x) x / sum(x))

# Construct Taxonomic table
taxtab <- as(tax_table(genus_relabund), "matrix")
taxtab <- as.data.frame(taxtab)
tax_df<- otu_table(genus_relabund, "matrix")
tax_df<- as.data.frame(tax_df)

# Match column names of otu_table with genus names in genus_data
matching_cols <- intersect(colnames(tax_df), rownames(taxtab))

# Rename columns in otu_table based on matched genus names
colnames(tax_df)[colnames(tax_df) %in% matching_cols] <- 
  taxtab$Genus[rownames(taxtab) %in% matching_cols]

# # tax_df has sample IDs as rows and genus names as columns 
# the data includes only taxa that have valid genus-level names.
dim(tax_df)
# 40 sampelids
# 389 genus

# Ensure rownames match and are aligned in before merging the metadata.
genus_abundance <- tax_df[rownames(meta), ]

# Left bind (metadata on the left, genus abundance on the right)
Genus_taxa <- cbind(genus_abundance, meta)

# make one more colum based on the group jejunum mucosa and content
# extract the last character of a string from sample_alias and assign
#it to a new column site in the Genus_taxa
Genus_taxa$site <- substr(Genus_taxa$sample_alias, 
                          nchar(Genus_taxa$sample_alias), 
                          nchar(Genus_taxa$sample_alias))



##  Taxa at species level
# Aggregate data on the genus level
species_level <- tax_glom(ps, "Species")

# Transform to relative abundance
species_relabund <- transform_sample_counts(species_level,function(x) x / sum(x))

# Construct Taxonomic table
taxtab_spe <- as(tax_table(species_relabund), "matrix")
taxtab_spe <- as.data.frame(taxtab_spe)

# Merge Genus and Species columns with an underscore to make it easy to spell.
taxtab_spe$Genus_Species <- paste(taxtab_spe$Genus, taxtab_spe$Species, sep = "_")
tax_df_spe<- otu_table(species_relabund, "matrix")
tax_df_spe<- as.data.frame(tax_df_spe)

# Match column names of otu_table with species names in species_data
matching_cols_spe <- intersect(colnames(tax_df_spe), rownames(taxtab_spe))

# Rename columns in otu_table based on matched species names
colnames(tax_df_spe)[colnames(tax_df_spe) %in% matching_cols_spe] <- 
  taxtab_spe$Genus_Species[rownames(taxtab_spe) %in% matching_cols_spe]

# # tax_df has sample IDs as rows and species names as columns 
# the data includes only taxa that have valid species-level names.
dim(tax_df_spe)
# 40 sampelids
# 270 species

# Ensure rownames match and are aligned in before merging the metadata.
species_abundance <- tax_df_spe[rownames(meta), ]

# Left bind (metadata on the left, species abundance on the right)
Species_taxa <- cbind(species_abundance, meta)

# make one more colum based on the group jejunum mucosa and content
# extract the last character of a string from sample_alias and assign
#it to a new column site in the species_taxa
Species_taxa$site <- substr(species_taxa$sample_alias, 
                          nchar(species_taxa$sample_alias), 
                          nchar(species_taxa$sample_alias))


write.csv(Genus_taxa, file = "/home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects/Genus_taxonomy.csv")
write.csv(Species_taxa, file = "/home/karthi/bioai/Team2_AI_Microbiome_Poultry/objects/Species_taxonomy.csv")
