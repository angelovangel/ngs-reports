# obtain statistics about a bunch of fastq files
# !! using seqkit and GNU parallel - have to be available in your PATH !!
# due to GNU parallel - much faster than fastqc for example

# input - a vector with fastq file names
# output - a dataframe with file names and fastq statistics
require(readr)
require(dplyr)

seqkit_stats <- function(fastqfiles) {
  seqkitcolnames <- c("file",	"format",	"type",	"num_seqs",	"sum_len",	"min_len",	
                    "avg_len",	"max_len",	"Q1",	"Q2",	"Q3",	"sum_gap",	"N50",	"Q20(%)",	"Q30(%)")
  # each output line has a header, remove it with sed
  read_delim(system2(
    "parallel",
    args = c("-k", "seqkit", "stats", "-a", "-T", ":::", fastqfiles,"| sed -n '/^file/!p'"),
    stdout = TRUE),
  delim = "\t",
  col_names = seqkitcolnames) %>%
  dplyr::mutate(file = basename(file))
}


