# seqkit fx2tab -g | cut -f 4 --> hist --> heatmap rows are reads, cols are breaks, color is density

# obtain gc histograms about a bunch of fastq files
# !! using seqkit and GNU parallel - have to be available in your PATH !!
# due to GNU parallel - much faster than fastqc for example

# input - a vector with fastq file names
# output - a dataframe with file names and gc hist data
seqkit_gc <- function(fastqfiles) {
  
  
}
