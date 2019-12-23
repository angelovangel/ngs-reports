# RSeQC read strandness modules
# RSeQC has to be installed and the python scripts have to be available in the $PATH
# This file defines XX functions:
#---------------------------------
# rseqc_strand(bedfile, bamfiles, outdir)
# takes a bedfile and a list of bam file paths, executes infer_experiment.py 
# and writes to outdir, deletes unneeded files

# rseqc_strand_getdf(outdir)
# takes the outdir from the previous function as argument and returns a df with results


require(stringr)
require(dplyr)
require(parallel)
require(purrr)

  
  # rseqc_strand(bedfile, bamfiles, outdir)
  rseqc_strand <- function(bedfile, bamfiles, outdir) {
    
      infer_exp <- function(x) { 
        system2(command = "infer_experiment.py", 
              args = c("-i", x, 
                       "-r", bedfile, 
                       ">", 
                       file.path(outdir, paste(tools::file_path_sans_ext(basename(x)), 
                                               ".infer_experiment.txt", sep = "")
                                 ), 
                       "2>&1")
              )
      }
    # execute infer_experiment.py  
    parallel::mclapply(bamfiles, infer_exp)
  }
  
  # rseqc_strand_getdf(outdir)
  rseqc_strand_getdf <- function(outdir) {
      # patterns to look for, using positive look behind. The aim is to get the number out
      # Total reads sampled 
      total_sampled <- "(?<=Total )\\d+"
    
      # Fraction of reads failed to determine 
      failed_to_determine <- "(?<=failed to determine: )\\d.*"
      # Fraction of reads explained by (PE)
      pe_sense <- "(?<=explained by \"1\\+\\+,1--,2\\+-,2-\\+\": )\\d.*"
      pe_antisense <- "(?<=explained by \"1\\+-,1-\\+,2\\+\\+,2--\": )\\d.*"
    
      # Fraction of reads explained by (SE)
      se_sense <- "(?<=explained by \"\\+\\+,--\": )\\d.*"
      se_antisense <- "(?<=explained by \"\\+-,-\\+\": )\\d.*"
      
      # func to execute on each output file
      read_infer_experiment <- function(x) { 
          
          # read once, then grep out what is needed
          infer_exp_file <- readLines(x)
          
          if(length(grep(pattern = "This is PairEnd Data", x = infer_exp_file)) > 0) {
            # construct a named list which will be later converted to df
            list(
              filename = basename(x),
              reads_sampled = grep(pattern = total_sampled, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(total_sampled) %>% 
                as.numeric(),
              pe_sense = grep(pattern = pe_sense, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(pe_sense) %>% 
                as.numeric(),
              pe_antisense = grep(pattern = pe_antisense, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(pe_antisense) %>% 
                as.numeric(),
              failed_to_determine = grep(pattern = failed_to_determine, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(failed_to_determine) %>% 
                as.numeric()
            )
          } else if(length(grep(pattern = "This is SingleEnd Data", x = infer_exp_file)) > 0) {
            list(
              filename = basename(x),
              reads_sampled = grep(pattern = total_sampled, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(total_sampled) %>% 
                as.numeric(),
              se_sense = grep(pattern = se_sense, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(se_sense) %>% 
                as.numeric(),
              se_antisense = grep(pattern = se_antisense, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(se_antisense) %>% 
                as.numeric(),
              failed_to_determine = grep(pattern = failed_to_determine, x = infer_exp_file, perl = TRUE, value = TRUE) %>% 
                str_extract(failed_to_determine) %>% 
                as.numeric()
            )
          } else {
            stop("Could not determine if this is PE or SE data, check the output of infer_experiment.py")
          }
      }
    
    list.files(path = outdir, 
               pattern = "*.infer_experiment.txt", 
               full.names = TRUE) %>% 
      map_df(read_infer_experiment)
  }
  
  
  
  