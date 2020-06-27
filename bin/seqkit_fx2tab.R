# seqkit fx2tab -g | cut -f 4 --> hist --> heatmap rows are reads, cols are breaks, color is density

# use -q and -l for quality and length also?

# obtain gc histograms about a bunch of fastq files
# !! using seqkit and GNU parallel - have to be available in your PATH !!
# due to GNU parallel - much faster than fastqc for example

# input - a vector with fastq file names
# output - a dataframe with file names and gc hist data

require(dplyr)

seqkit_gc <- function(x) {
  system2("seqkit", args = c("fx2tab", "-g", x, "| cut -f 4"), stdout = TRUE) %>%
    as.numeric() %>%
    # actually use density() here, not hist(). It returns a density list object with x and y, x is fixed from 1 to 100
    density(from = 1, to = 100, n = 100, na.rm = TRUE) # n is the number of equally spaced points at which the density is to be estimated.
    #hist(plot = FALSE, breaks = c(0:100))
}

# fix length from 1 to 300 for illumina data
seqkit_len <- function(x) {
  system2("seqkit", args = c("fx2tab", "-l", x, "| cut -f 4"), stdout = TRUE) %>%
    as.numeric() %>%
    # actually use density() here, not hist(). It returns a density list object with x and y, x is fixed from 1 to 300
    density(from = 1, to = 300, n = 300, na.rm = TRUE) # n is the number of equally spaced points at which the density is to be estimated.
  #
}

seqkit_qscore <- function(x) {
  system2("seqkit", args = c("fx2tab", "-q", x, "| cut -f 4"), stdout = TRUE) %>%
    as.numeric() %>%
    # actually use density() here, not hist(). It returns a density list object with x and y, x is fixed from 1 to 50
    density(from = 1, to = 50, n = 50, na.rm = TRUE) # n is the number of equally spaced points at which the density is to be estimated.
  #
}
