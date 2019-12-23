# RSeQC dup rate module
# RSeQC has to be installed and the python scripts have to be available in the $PATH
# This file defines 2 functions:
#---------------------------------
# rseqc_duprate(bamfiles, outdir)
# takes a list of bam file paths, executes read_duplication.py and writes to outdir, deletes unneeded files

# rseqc_duprate_getdf(outdir)
# takes the outdir from the previous function as argument and returns a df with results

# 
#

require(dplyr)
require(parallel)
require(purrr)
require(data.table)

  
  # rseqc_duprate(bamfiles, outdir)
  rseqc_duprate <- function(bamfiles, outdir) {
    
    read_dup <- function(x) { 
      system2(command = "read_duplication.py", 
              args = c("-i", x, "-o", file.path(outdir, basename(x))
              )
      )
    }
  # execute read_duplication.py  
  parallel::mclapply(bamfiles, read_dup)
  
  # remove unneeded files
  #duprate_files_todelete <- list.files(path = outdir, pattern = "DupRate_plot", full.names = TRUE)
  #unlink(duprate_files_todelete, recursive = TRUE, force = TRUE)
  }
  
  
  # rseqc_duprate_getdf(outdir)
  rseqc_duprate_getdf <- function(outdir) {
    
    read_plus <- function(x) { fread(x) %>% mutate(flnm = basename(x)) }
    
    list.files(path = outdir, 
               pattern = "*.xls$", 
               full.names = TRUE) %>% 
      map_df(~read_plus(.))
  }
  
  
  
  