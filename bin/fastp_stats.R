# fastp on one SE fastq file or a pair of PE files

# INPUT - a character vector with fastq file names
# OUTPUT - a list containing:
# $filt -> a named vector with filter results
# $dup -> an integer vector (histogram)
# $percycle -> dataframe with per cycle data from fastp for this file or pair

# Implementation - runs fastp with system2 call, using parallel
# reads in the data from the json produced by fastp and constructs a dataframe

# constructed with fastp=0.20.0

require(parallel)
require(dplyr)
require(jsonlite)

fastp_se <- function(x, save_trimmed = FALSE) {
  fastq_name <- basename(x)
  json_name <- paste(fastq_name, ".json", sep = "")
  html_name <- paste(fastq_name, ".html", sep = "")
  
  if(isTRUE(save_trimmed)) {
    system2("fastp", args = c("-i", x, 
                              "-o", paste("trim_", basename(x), sep = ""),
                              "-j", json_name, "-h", html_name)) # you can discards the html with /dev/null
  } else {
    system2("fastp", args = c("-i", x, "-j", json_name, "-h", html_name))
  }
  
  j <- jsonlite::fromJSON(json_name)
  bf_per_cycle <- data.frame(cycle = 1:j$read1_before_filtering$total_cycles,
                             r1_q_per_cycle = j$read1_before_filtering$quality_curves$mean,
                             r1_gc_per_cycle = j$read1_before_filtering$content_curves$GC,
                             fastp_filter = "before")
  af_per_cycle <- data.frame(cycle = 1:j$read1_after_filtering$total_cycles,
                             r1_q_per_cycle = j$read1_after_filtering$quality_curves$mean,
                             r1_gc_per_cycle = j$read1_after_filtering$content_curves$GC,
                             fastp_filter = "after")
  
  return(
    list(total_bf = j$summary$before_filtering, 
         total_af = j$summary$after_filtering,
         filt = j$filtering_result,
         dup = j$duplication$histogram,
         percycle = rbind(bf_per_cycle, af_per_cycle)
    )
  )
  
}

fastp_pe <- function(x, y, save_trimmed = FALSE) {
  fastq_name <- basename(x)      # think about how to name these samples, now they get R1 names
  json_name <- paste(fastq_name, ".json", sep = "")
  html_name <- paste(fastq_name, ".html", sep = "")
  
  if(isTRUE(save_trimmed)) {
    system2("fastp", args = c("-i", x, 
                              "-I", y,
                              "-o", paste("trim_", basename(x), sep = ""),
                              "-O", paste("trim_", basename(y), sep = ""),
                              "-j", json_name, "-h", html_name)) # you can discards the html with /dev/null
  } else {
    system2("fastp", args = c("-i", x, 
                              "-I", y,
                              #"-o", paste("trim_", basename(x), sep = ""),
                              #"-O", paste("trim_", basename(y), sep = ""),
                              "-j", json_name, "-h", html_name)) 
  }
  
  j <- jsonlite::fromJSON(json_name)
  bf_per_cycle <- data.frame(cycle = 1:j$read1_before_filtering$total_cycles,
                             r1_q_per_cycle = j$read1_before_filtering$quality_curves$mean,
                             r1_gc_per_cycle = j$read1_before_filtering$content_curves$GC,
                             r2_q_per_cycle = j$read2_before_filtering$quality_curves$mean,
                             r2_gc_per_cycle = j$read2_before_filtering$content_curves$GC,
                             fastp_filter = "before")
  af_per_cycle <- data.frame(cycle = 1:j$read1_after_filtering$total_cycles,
                             r1_q_per_cycle = j$read1_after_filtering$quality_curves$mean,
                             r1_gc_per_cycle = j$read1_after_filtering$content_curves$GC,
                             r2_q_per_cycle = j$read2_after_filtering$quality_curves$mean,
                             r2_gc_per_cycle = j$read2_after_filtering$content_curves$GC,
                             fastp_filter = "after")
  
  return(
    list(total_bf = j$summary$before_filtering, 
         total_af = j$summary$after_filtering,
         filt = j$filtering_result,
         dup = j$duplication$histogram,
         percycle = rbind(bf_per_cycle, af_per_cycle)
    )
  )
  
}

