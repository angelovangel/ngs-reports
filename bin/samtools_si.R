 # samtools sort and index
 # samtools has to be installed and in your PATH
 
 # Defines the functions
 # samtools_sort(bamfile) and samtools_index(sortedbamfile)
 # INPUT: a BAM file path
 # OUTPUT: nothing, executes samtools sort and samtools index and writes to the same directory where the BAM files are
 
 ##-------------------------------
 # seems the command is executed in the dir where the bam files are 
samtools_sort <- function(bamfile) {
  system2("samtools", 
          args = c("sort", 
                   "--threads 4",
                   bamfile), 
          stdout = paste(tools::file_path_sans_ext(bamfile), ".sorted.bam", sep = "")
          )
}
##-------------------------------
samtools_index <- function(sortedbamfile) {
  system2("samtools", 
          args = c("index",
                   "-@ 4",
                   sortedbamfile
          )
  )
}


