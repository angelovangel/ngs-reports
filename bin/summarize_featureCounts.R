# This function takes the output of featureCounts() from the Rsubread package and
# outputs a data frame summary grouped on the gene_biotype attribute

# For it to work, featureCounts() has to be run with the GTF.attrType.extra = "gene_biotype" argument,
# and the gene_biotype has to be present in the GTF file

# Also, the bam files used have to end with "BAM" (as is the case if align() from Rsubread was used)

# USAGE
# The function uses NSE, so if the grouping var is gene_biotype, it can be used
# directly as summarize_featureCounts(fc, gene_biotype)

require(stringr)
require(readr)
require(dplyr)

summarize_featureCounts <- function(x) {
  #group_var <- enquo(group)
  
  as.data.frame(x$counts) %>% 
    mutate(GeneID = rownames(.)) %>% #add GeneID var using the rownames
    left_join(x$annotation) %>% #join with annotations, which contain gene_biotype
    group_by(gene_biotype) %>% 
    summarise_at(vars(ends_with("BAM")), sum) %>% # counts per gene_biotype
    rename_at(vars(ends_with("BAM")), 
              list(~str_remove(string = ., pattern = ".R(1|2).001.*fastq.gz.subread.BAM")
                   )
              ) #%>%  #just prettify vars
  
    #mutate_if(is.numeric, list(percent = ~100*./sum(.) )) #add percentage vars
}

# summarize featureCounts when a saf file has been used as input
# the saf file has to be generated with prokka_gff2saf.sh (or has to have a gene_biotype var)
summarize_featureCounts_saf <- function(fc, saf) {
  
  saffile <- read_delim(saf, delim = "\t")
  
  as.data.frame(fc$counts) %>% 
    mutate(GeneID = rownames(.)) %>% #add GeneID var using the rownames
    left_join(saffile, by = "GeneID") %>% #join with annotations, which contain gene_biotype
    group_by(gene_biotype) %>% 
    summarise_at(vars(ends_with("BAM")), sum) %>% # counts per gene_biotype
    rename_at(vars(ends_with("BAM")), 
              list(~str_remove(string = ., pattern = ".R(1|2).001.*fastq.gz.subread.BAM") #just prettify vars
              )
    ) 
}